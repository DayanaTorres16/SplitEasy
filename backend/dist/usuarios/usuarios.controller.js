"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UsuariosController = void 0;
const common_1 = require("@nestjs/common");
const passport_1 = require("@nestjs/passport");
const usuarios_service_1 = require("./usuarios.service");
const update_usuario_dto_1 = require("./dto/update-usuario.dto");
const change_password_dto_1 = require("./dto/change-password.dto");
let UsuariosController = class UsuariosController {
    usuariosService;
    constructor(usuariosService) {
        this.usuariosService = usuariosService;
    }
    async getProfile(req) {
        const userId = req.user.userId;
        const usuario = await this.usuariosService.findById(userId);
        if (!usuario)
            throw new common_1.NotFoundException('Usuario no encontrado');
        const { password_hash, ...result } = usuario;
        return result;
    }
    async updateProfile(req, dto) {
        const userId = req.user.userId;
        return this.usuariosService.updateProfile(userId, dto);
    }
    async changePassword(req, dto) {
        const userId = req.user.userId;
        return this.usuariosService.changePassword(userId, dto);
    }
    async logout() {
        return { message: 'Sesión cerrada correctamente en el servidor' };
    }
    async buscarPorEmail(email) {
        return await this.usuariosService.findByEmail(email);
    }
};
exports.UsuariosController = UsuariosController;
__decorate([
    (0, common_1.Get)('profile'),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], UsuariosController.prototype, "getProfile", null);
__decorate([
    (0, common_1.Patch)('profile'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, update_usuario_dto_1.UpdateUsuarioDto]),
    __metadata("design:returntype", Promise)
], UsuariosController.prototype, "updateProfile", null);
__decorate([
    (0, common_1.Patch)('change-password'),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, change_password_dto_1.ChangePasswordDto]),
    __metadata("design:returntype", Promise)
], UsuariosController.prototype, "changePassword", null);
__decorate([
    (0, common_1.Patch)('logout'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], UsuariosController.prototype, "logout", null);
__decorate([
    (0, common_1.Get)('buscar'),
    __param(0, (0, common_1.Query)('email')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], UsuariosController.prototype, "buscarPorEmail", null);
exports.UsuariosController = UsuariosController = __decorate([
    (0, common_1.Controller)('users'),
    (0, common_1.UseGuards)((0, passport_1.AuthGuard)('jwt')),
    __metadata("design:paramtypes", [usuarios_service_1.UsuariosService])
], UsuariosController);
//# sourceMappingURL=usuarios.controller.js.map