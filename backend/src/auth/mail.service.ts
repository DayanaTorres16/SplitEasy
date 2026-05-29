import { Injectable, Logger } from '@nestjs/common';
import nodemailer, { Transporter } from 'nodemailer';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class MailService {
  private readonly logger = new Logger(MailService.name);
  private enabled = false;
  private transporter: Transporter | null = null;
  private from = '';

  constructor(private configService: ConfigService) {
    const host = this.configService.get<string>('MAIL_HOST') ?? this.configService.get<string>('SMTP_HOST');
    const port = Number(this.configService.get<string>('MAIL_PORT') ?? this.configService.get<string>('SMTP_PORT') ?? 587);
    const user = this.configService.get<string>('MAIL_USER') ?? this.configService.get<string>('SMTP_USER');
    const pass = this.configService.get<string>('MAIL_PASS') ?? this.configService.get<string>('SMTP_PASS');
    this.from = this.configService.get<string>('MAIL_FROM') ?? this.configService.get<string>('SMTP_FROM') ?? 'tdayana1609@gmail.com';

    if (!host || !user || !pass || !this.from) {
      this.logger.warn('MAIL_HOST/MAIL_USER/MAIL_PASS/MAIL_FROM are not fully configured — emails will be disabled');
      return;
    }

    const secure = String(this.configService.get<string>('MAIL_SECURE') ?? this.configService.get<string>('SMTP_SECURE') ?? (port === 465 ? 'true' : 'false')).toLowerCase() === 'true';
    const rejectUnauthorized = String(
      this.configService.get<string>('MAIL_TLS_REJECT_UNAUTHORIZED') ??
      this.configService.get<string>('SMTP_TLS_REJECT_UNAUTHORIZED') ??
      'true',
    ).toLowerCase() === 'true';

    this.transporter = nodemailer.createTransport({
      host,
      port,
      secure,
      auth: { user, pass },
      tls: { rejectUnauthorized },
    });

    this.enabled = true;
  }

  async sendForgotPassword(email: string, resetLink: string): Promise<{ sent: boolean; error?: string; resetLink?: string }> {
    if (!this.enabled) {
      this.logger.warn(`Mail disabled — skipping forgot-password email to ${email}`);
      return { sent: false, resetLink };
    }

    if (!this.transporter) {
      this.logger.error('Mail transporter is not configured');
      throw new Error('Mail transporter is not configured');
    }

    const message = {
      to: email,
      from: this.from,
      subject: 'Restablece tu contraseña',
      text: `Accede al siguiente enlace para restablecer tu contraseña: ${resetLink}`,
      html: `<p>Accede al siguiente enlace para restablecer tu contraseña:</p><p><a href="${resetLink}">${resetLink}</a></p>`,
    };

    try {
      await this.transporter.sendMail(message);
      return { sent: true };
    } catch (error: any) {
      const errMsg = error?.message ?? 'Unknown mail error';
      this.logger.error('Mail send error: ' + errMsg);
      return { sent: false, error: errMsg, resetLink };
    }
  }
}
