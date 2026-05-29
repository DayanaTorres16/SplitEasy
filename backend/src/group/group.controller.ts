import { Controller, Post, Body, Req, Get } from '@nestjs/common';
import { GruposService } from './group.service';
import { CreateGroupDto } from './dto/create-group.dto';
import { CreateExpenseDto } from '../add_expense/dto/create-expense.dto';

@Controller('grupos')
export class GruposController {
  constructor(private readonly gruposService: GruposService) {}

  @Post()
  async crearGrupo(@Body() createGroupDto: CreateGroupDto, @Req() req: any) {
    // Forzamos ID 2 si el token no se pudo leer
    const usuarioId = req.user?.sub ?? 2; 
    return this.gruposService.crear(createGroupDto, usuarioId);
  }

  @Post('gasto')
  async crearGasto(@Body() createExpenseDto: CreateExpenseDto, @Req() req: any) {
    // Forzamos ID 2 si el token no se pudo leer
    const usuarioId = req.user?.sub ?? 2;
    return this.gruposService.registrarGasto(createExpenseDto, usuarioId);
  }

  @Get()
  async listarMisGrupos(@Req() req: any) {
    // Forzamos ID 2 para que siempre devuelva tus grupos
    const usuarioId = req.user?.sub ?? 2;
    return this.gruposService.obtenerGruposPorUsuario(usuarioId);
  }
}