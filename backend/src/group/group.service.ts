import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Grupo } from './group.entity';
import { Expense } from '../add_expense/expense.entity';
import { Usuario } from '../usuarios/usuario.entity';
import { CreateGroupDto } from './dto/create-group.dto';
import { CreateExpenseDto } from '../add_expense/dto/create-expense.dto';

@Injectable()
export class GruposService {
  constructor(
    @InjectRepository(Grupo) private readonly grupoRepository: Repository<Grupo>,
    @InjectRepository(Expense) private readonly expenseRepository: Repository<Expense>,
    @InjectRepository(Usuario) private readonly usuarioRepository: Repository<Usuario>,
  ) {}

  async crear(dto: CreateGroupDto, usuarioId: number): Promise<Grupo> {
    const ids = Array.from(new Set([usuarioId, ...(dto.miembrosIds || [])]));
    const usuarios = await this.usuarioRepository.findBy({ id: In(ids) });

    const nuevoGrupo = this.grupoRepository.create({
      ...dto,
      miembros: usuarios,
    });
    return await this.grupoRepository.save(nuevoGrupo);
  }

  async registrarGasto(dto: CreateExpenseDto, usuarioId: number): Promise<Expense> {
    const grupo = await this.grupoRepository.findOne({ where: { id: dto.grupoId as any } });
    if (!grupo) throw new NotFoundException('Grupo no encontrado');

    const nuevoGasto = this.expenseRepository.create({
      monto: dto.monto,
      descripcion: dto.descripcion,
      categoria: dto.categoria,
      grupo: grupo,
      pagadoPor: { id: usuarioId } as any,
    });

    return await this.expenseRepository.save(nuevoGasto);
  }

  async obtenerGruposPorUsuario(usuarioId: number): Promise<Grupo[]> {
    return await this.grupoRepository.find({
      where: { miembros: { id: usuarioId } },
      relations: {
        miembros: true,
      },
    });
  }
}