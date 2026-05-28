import { Controller, Get, Body, Patch, UseGuards, Req, NotFoundException } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { UsuariosService } from './usuarios.service';
import { UpdateUsuarioDto } from './dto/update-usuario.dto';
import { ChangePasswordDto } from './dto/change-password.dto';

@Controller('users')
@UseGuards(AuthGuard('jwt')) // Protege todos los endpoints de este controlador
export class UsuariosController {
  constructor(private readonly usuariosService: UsuariosService) {}

  // GET /users/profile -> Obtiene los datos del usuario logueado
  @Get('profile')
  async getProfile(@Req() req: any) {
    const userId = req.user.userId; // Viene de tu JwtStrategy
    const usuario = await this.usuariosService.findById(userId);
    
    if (!usuario) throw new NotFoundException('Usuario no encontrado');
    
    // Quitamos la contraseña antes de mandarla a Flutter
    const { password_hash, ...result } = usuario;
    return result;
  }

  // PATCH /users/profile -> Actualiza nombre o email
  @Patch('profile')
  async updateProfile(@Req() req: any, @Body() dto: UpdateUsuarioDto) {
    const userId = req.user.userId;
    return this.usuariosService.updateProfile(userId, dto);
  }

  // PATCH /users/change-password -> Cambia la contraseña validando la anterior
  @Patch('change-password')
  async changePassword(@Req() req: any, @Body() dto: ChangePasswordDto) {
    const userId = req.user.userId;
    return this.usuariosService.changePassword(userId, dto);
  }

  // POST /users/logout -> ¿Qué pasa con el cierre de sesión?
  // Como manejas JWT simples (sin base de datos de tokens inválidos o Redis), 
  // la mejor práctica y la más limpia para apps móviles es destruir el token en el Front (Flutter).
  // Dejamos un endpoint por si en el futuro quieres registrar logs o borrar push tokens:
  @Patch('logout')
  async logout() {
    return { message: 'Sesión cerrada correctamente en el servidor' };
  }
}
