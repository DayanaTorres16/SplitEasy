import { ConflictException, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { UsuariosService } from '../usuarios/usuarios.service';
import { CreateUserDto } from './dto/create-user.dto';
import { MailService } from './mail.service';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly usuariosService: UsuariosService,
    private readonly jwtService: JwtService,
    private readonly mailService: MailService,
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
      return { message: 'Correo no registrado' };
    }

    const payload = { sub: usuario.id, email: usuario.email };
    const token = this.jwtService.sign(payload, { expiresIn: '15m' });

    const frontUrl = process.env.FRONT_URL ?? 'http://localhost:3000';
    const resetLink = `${frontUrl}/new-password?token=${token}`;

    const result = await this.mailService.sendForgotPassword(usuario.email, resetLink);

    // If SendGrid failed but developer wants the token in response for testing, allow it
    const devReturn = (process.env.SENDGRID_DEV_RETURN_TOKEN ?? 'false').toLowerCase() === 'true';
    if (!result.sent && devReturn) {
      return { message: 'Correo (simulado) enviado', resetLink };
    }

    return { message: 'Correo enviado con instrucciones' };
  }

  async resetPassword(dto: ResetPasswordDto) {
    try {
      const payload: any = this.jwtService.verify(dto.token);
      const usuario = await this.usuariosService.findById(payload.sub);
      if (!usuario) return { message: 'Usuario no encontrado' };

      if (dto.newPassword !== dto.confirmPassword) {
        return { message: 'Las contraseñas no coinciden' };
      }

      const hashed = await bcrypt.hash(dto.newPassword, 10);
      await this.usuariosService.updatePassword(usuario.id, hashed);

      return { message: 'Contraseña actualizada correctamente' };
    } catch (err) {
      return { message: 'Token inválido o expirado' };
    }
  }
}
