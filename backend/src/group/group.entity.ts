import { Entity, PrimaryGeneratedColumn, Column, ManyToMany, JoinTable, CreateDateColumn } from 'typeorm';
import { Usuario } from '../usuarios/usuario.entity';

@Entity('grupos')
export class Grupo {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 100 })
  nombre: string;

  @Column({ type: 'text', nullable: true })
  descripcion: string;

  @Column({ type: 'integer', default: 0 })
  iconoIndex: number;

  @CreateDateColumn()
  fechaCreacion: Date;

  @ManyToMany(() => Usuario, (usuario) => usuario.grupos, { cascade: true })
  @JoinTable({
    name: 'miembros_grupo', 
    joinColumn: { name: 'grupo_id', referencedColumnName: 'id' },
    inverseJoinColumn: { name: 'usuario_id', referencedColumnName: 'id' }
  })
  miembros: Usuario[];
}