import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './auth/auth.module';
import { UsuariosModule } from './usuarios/usuarios.module';
import { GruposModule } from './group/group.module';
import { ExpenseModule } from './expense/expense.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true, 
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        type: 'postgres',
        host: config.get<string>('DB_HOST') ?? 'localhost',
        port: Number(config.get<string>('DB_PORT') ?? 5432),
        username: config.get<string>('DB_USERNAME') ?? 'postgres',
        password: String(config.get<string>('DB_PASSWORD') ?? ''),
        database: config.get<string>('DB_NAME') ?? 'spliteasy',
        autoLoadEntities: true, 
        synchronize: true, 
      }),
    }),
    UsuariosModule,
    AuthModule,
    GruposModule, 
    ExpenseModule,
  ],
})
export class AppModule {}
