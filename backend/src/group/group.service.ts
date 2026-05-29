import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In, EntityManager } from 'typeorm';
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
  ) {}

  async crear(dto: CreateGroupDto, usuarioId: number): Promise<Grupo> {
    // 1. Crear grupo sin asignar miembros directamente
    return await this.grupoRepository.manager.transaction(async (manager: EntityManager) => {
      const nuevoGrupo = manager.create(Grupo, {
        nombre: dto.nombre,
        descripcion: dto.descripcion,
        iconoIndex: dto.iconoIndex,
      });

      const saved = await manager.save(nuevoGrupo);

      const ids = Array.from(new Set([usuarioId, ...(dto.miembrosIds || [])]));
      const usuarios = await manager.findBy(Usuario, { id: In(ids) });
      saved.miembros = usuarios;
      await manager.save(saved);

      // External members removed: skip creating external member records

      return saved;
    });
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

  async obtenerPorId(grupoId: string): Promise<{ grupo: Grupo; gastos: Expense[] }> {
    const grupo = await this.grupoRepository.findOne({
      where: { id: grupoId },
      relations: { miembros: true },
    });

    if (!grupo) throw new NotFoundException('Grupo no encontrado');

    const gastos = await this.expenseRepository.find({
      where: { grupo: { id: grupoId } },
      relations: { pagadoPor: true },
      order: { fechaGasto: 'DESC' },
    });

    return { grupo, gastos };
  }
}
