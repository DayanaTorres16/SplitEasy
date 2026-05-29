import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { GruposService } from './group.service';
import { GruposController } from './group.controller';
import { Grupo } from './group.entity';
import { Usuario } from '../usuarios/usuario.entity'; 
import { Expense } from '../add_expense/expense.entity'; 

@Module({
  imports: [
    TypeOrmModule.forFeature([Grupo, Usuario, Expense]), 
  ],
  controllers: [GruposController],
  providers: [GruposService],
  exports: [GruposService], 
})
export class GruposModule {}