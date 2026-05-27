import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Usuario } from './usuario.entity';

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

  findByEmail(email: string): Promise<Usuario | null> {
    return this.repo.findOne({ where: { email } });
  }

  async create(data: Partial<Usuario>): Promise<Usuario> {
    const user = this.repo.create(data);
    return this.repo.save(user);
  }

  async updatePassword(id: number, passwordHash: string): Promise<Usuario> {
    const user = await this.repo.findOne({ where: { id } });
    if (!user) throw new Error('Usuario no encontrado');
    user.password_hash = passwordHash;
    return this.repo.save(user);
  }
}
