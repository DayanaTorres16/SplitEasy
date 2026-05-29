import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Expense } from '../add_expense/expense.entity'; 
import { GastosController } from './gastos.controller';
import { GastosService } from './gastos.service';

@Module({
  imports: [TypeOrmModule.forFeature([Expense])], 
  controllers: [GastosController],
  providers: [GastosService],
})
export class ExpenseModule {}