import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Usuario } from '../usuarios/usuario.entity'; 
import { Grupo } from '../group/group.entity'; 

@Entity('gastos')
export class Expense { 
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  monto!: number;

  @Column()
  descripcion!: string;

  @Column({ default: 'Comida' })
  categoria!: string;

  @CreateDateColumn({ name: 'fecha_gasto' })
  fechaGasto!: Date;

  @ManyToOne(() => Usuario, { eager: true, onDelete: 'CASCADE' })
  @JoinColumn({ name: 'pagado_por_id' })
  pagadoPor!: Usuario;

  @ManyToOne(() => Grupo, { onDelete: 'CASCADE' }) 
  @JoinColumn({ name: 'grupo_id' })
  grupo!: Grupo;
}