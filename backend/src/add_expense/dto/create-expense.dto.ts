import { IsString, IsNotEmpty, IsNumber, IsPositive } from 'class-validator';

export class CreateExpenseDto {
  @IsNumber()
  @IsNotEmpty()
  @IsPositive()
  monto!: number;

  @IsString()
  @IsNotEmpty()
  descripcion!: string;

  @IsString()
  @IsNotEmpty()
  categoria!: string;

  @IsString() 
  @IsNotEmpty()
  grupoId!: string; 
}