import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Expense } from '../add_expense/expense.entity'; // Importamos la entidad base
import { GastosController } from './gastos.controller';
import { GastosService } from './gastos.service';

@Module({
  imports: [TypeOrmModule.forFeature([Expense])], // Registramos la entidad aquí
  controllers: [GastosController],
  providers: [GastosService],
})
export class ExpenseModule {}