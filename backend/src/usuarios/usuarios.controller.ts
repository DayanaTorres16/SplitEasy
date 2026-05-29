import { Controller, Get, Body, Patch, UseGuards, Req, NotFoundException, Query } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { UsuariosService } from './usuarios.service';
import { UpdateUsuarioDto } from './dto/update-usuario.dto';
import { ChangePasswordDto } from './dto/change-password.dto';

@Controller('users')
@UseGuards(AuthGuard('jwt'))
export class UsuariosController {
  constructor(private readonly usuariosService: UsuariosService) {}

  // GET Obtiene los datos del usuario logueado
  @Get('profile')
  async getProfile(@Req() req: any) {
    const userId = req.user.userId; // Viene de tu JwtStrategy
    const usuario = await this.usuariosService.findById(userId);
    
    if (!usuario) throw new NotFoundException('Usuario no encontrado');
    
    const { password_hash, ...result } = usuario;
    return result;
  }

  // PATCH Actualiza nombre o email
  @Patch('profile')
  async updateProfile(@Req() req: any, @Body() dto: UpdateUsuarioDto) {
    const userId = req.user.userId;
    return this.usuariosService.updateProfile(userId, dto);
  }

  // PATCH Cambia la contraseña validando la anterior
  @Patch('change-password')
  async changePassword(@Req() req: any, @Body() dto: ChangePasswordDto) {
    const userId = req.user.userId;
    return this.usuariosService.changePassword(userId, dto);
  }

  @Patch('logout')
  async logout() {
    return { message: 'Sesión cerrada correctamente en el servidor' };
  }

  @Get('buscar')
  async buscarPorEmail(@Query('email') email: string) {
    return await this.usuariosService.findByEmail(email);
  }
}
