import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Expense } from '../add_expense/expense.entity';

@Injectable()
export class GastosService {
  constructor(
    @InjectRepository(Expense)
    private gastosRepository: Repository<Expense>,
  ) {}

  async findAll(): Promise<Expense[]> {
    return await this.gastosRepository.find({
      relations: {
        pagadoPor: true,
        grupo: true,
      },
    });
  }
}