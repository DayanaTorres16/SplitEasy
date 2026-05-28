import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Usuario } from './usuario.entity';
import { UpdateUsuarioDto } from './dto/update-usuario.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsuariosService {
  constructor(
    @InjectRepository(Usuario)
    private readonly repo: Repository<Usuario>,
  ) {}

  findAll(): Promise<Usuario[]> {
    return this.repo.find();
  }

  findById(id: number): Promise<Usuario | null> {
    return this.repo.findOne({ where: { id } });
  }

  // CORREGIDO: Ahora mapea correctamente la propiedad 'email' con el argumento de la función
  findByEmail(email: string): Promise<Usuario | null> {
    return this.repo.findOne({ where: { email } }); 
  }

  async create(data: Partial<Usuario>): Promise<Usuario> {
    const user = this.repo.create(data);
    return this.repo.save(user);
  }

  // AGREGADO DE VUELTA: Tu AuthService lo necesita para el Reset Password por correo
  async updatePassword(id: number, passwordHash: string): Promise<Usuario> {
    const user = await this.repo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('Usuario no encontrado');
    user.password_hash = passwordHash;
    return this.repo.save(user);
  }

  // --- MÉTODOS DE ACTUALIZACIÓN DE PERFIL ---

  async updateProfile(id: number, dto: UpdateUsuarioDto): Promise<Omit<Usuario, 'password_hash'>> {
    const usuario = await this.findById(id);
    if (!usuario) throw new NotFoundException('Usuario no encontrado');

    if (dto.email && dto.email !== usuario.email) {
      const emailExists = await this.repo.findOne({ where: { email: dto.email } });
      if (emailExists) throw new BadRequestException('El correo ya está en uso');
    }

    this.repo.merge(usuario, dto);
    const updatedUser = await this.repo.save(usuario);

    const { password_hash, ...result } = updatedUser;
    return result;
  }

  async changePassword(id: number, dto: ChangePasswordDto): Promise<{ message: string }> {
    const usuario = await this.findById(id);
    if (!usuario) throw new NotFoundException('Usuario no encontrado');

    const isValid = await bcrypt.compare(dto.passwordActual, usuario.password_hash);
    if (!isValid) {
      throw new BadRequestException('La contraseña actual es incorrecta');
    }

    usuario.password_hash = await bcrypt.hash(dto.passwordNueva, 10);
    await this.repo.save(usuario);

    return { message: 'Contraseña actualizada correctamente' };
  }
}