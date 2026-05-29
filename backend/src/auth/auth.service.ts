import { ConflictException, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import * as bcrypt from 'bcrypt';
import * as crypto from 'crypto';
import { UsuariosService } from '../usuarios/usuarios.service';
import { CreateUserDto } from './dto/create-user.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { PasswordResetToken } from './password-reset-token.entity';
import { IsNull, MoreThan, Repository } from 'typeorm';

@Injectable()
export class AuthService {
  constructor(
    private readonly usuariosService: UsuariosService,
    private readonly jwtService: JwtService,
    @InjectRepository(PasswordResetToken)
    private readonly passwordResetTokenRepository: Repository<PasswordResetToken>,
  ) {}

  async validateUser(email: string, password: string): Promise<any> {
    const user = await this.usuariosService.findByEmail(email);
    if (!user) {
      throw new UnauthorizedException('Usuario no encontrado');
    }
    const isValid = await bcrypt.compare(password, user.password_hash);
    if (!isValid) {
      throw new UnauthorizedException('Credenciales inválidas');
    }
    return user;
  }

  async register(data: CreateUserDto) {
    const existingUser = await this.usuariosService.findByEmail(data.email);
    if (existingUser) {
      throw new ConflictException('El correo ya está registrado');
    }

    const passwordHash = await bcrypt.hash(data.password, 10);
    const fullName = `${data.name} ${data.lastName}`.trim();

    const user = await this.usuariosService.create({
      nombre: fullName,
      email: data.email,
      password_hash: passwordHash,
    });

    return {
      message: 'Usuario creado correctamente',
      user: {
        id: user.id,
        nombre: user.nombre,
        email: user.email,
      },
    };
  }

  async login(user: any) {
    const payload = { email: user.email, sub: user.id };
    return {
      access_token: this.jwtService.sign(payload),
    };
  }

  async forgotPassword(dto: ForgotPasswordDto) {
    const usuario = await this.usuariosService.findByEmail(dto.email);
    if (!usuario) {
      return { exists: false };
    }

    await this.passwordResetTokenRepository.delete({ userId: usuario.id });

    const token = crypto.randomBytes(32).toString('hex');
    const tokenHash = crypto.createHash('sha256').update(token).digest('hex');
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000);

    await this.passwordResetTokenRepository.save(
      this.passwordResetTokenRepository.create({
        userId: usuario.id,
        tokenHash,
        expiresAt,
        usedAt: null,
      }),
    );

    return { exists: true, resetToken: token };
  }

  async resetPassword(dto: ResetPasswordDto) {
    try {
      const tokenHash = crypto.createHash('sha256').update(dto.token).digest('hex');
      const resetToken = await this.passwordResetTokenRepository.findOne({
        where: {
          tokenHash,
          usedAt: IsNull(),
          expiresAt: MoreThan(new Date()),
        },
      });

      if (!resetToken) return { message: 'Token inválido o expirado' };

      const usuario = await this.usuariosService.findById(resetToken.userId);
      if (!usuario) return { message: 'Usuario no encontrado' };

      if (dto.newPassword !== dto.confirmPassword) {
        return { message: 'Las contraseñas no coinciden' };
      }

      const hashed = await bcrypt.hash(dto.newPassword, 10);
      await this.usuariosService.updatePassword(usuario.id, hashed);
      resetToken.usedAt = new Date();
      await this.passwordResetTokenRepository.save(resetToken);

      return { message: 'Contraseña actualizada correctamente' };
    } catch (err) {
      return { message: 'Token inválido o expirado' };
    }
  }
}
