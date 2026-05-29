import { Controller, Post, Body, Req, Get, Param } from '@nestjs/common';
import { GruposService } from './group.service';
import { CreateGroupDto } from './dto/create-group.dto';
import { CreateExpenseDto } from '../add_expense/dto/create-expense.dto';

@Controller('grupos')
export class GruposController {
  constructor(private readonly gruposService: GruposService) {}

  @Post()
  async crearGrupo(@Body() createGroupDto: CreateGroupDto, @Req() req: any) {
    const usuarioId = req.user?.sub ?? 2;
    return this.gruposService.crear(createGroupDto, usuarioId);
  }

  @Post('gasto')
  async crearGasto(@Body() createExpenseDto: CreateExpenseDto, @Req() req: any) {
    const usuarioId = req.user?.sub ?? 2;
    return this.gruposService.registrarGasto(createExpenseDto, usuarioId);
  }

  @Get()
  async listarMisGrupos(@Req() req: any) {
    const usuarioId = req.user?.sub ?? 2;
    return this.gruposService.obtenerGruposPorUsuario(usuarioId);
  }

  @Get(':id')
  async obtenerGrupo(@Param('id') id: string) {
    // Optional auth check can be added here
    return this.gruposService.obtenerPorId(id);
  }
}
