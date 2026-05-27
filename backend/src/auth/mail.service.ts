import { Injectable, Logger } from '@nestjs/common';
import sgMail = require('@sendgrid/mail');
import { ConfigService } from '@nestjs/config';

@Injectable()
export class MailService {
  private readonly logger = new Logger(MailService.name);
  private enabled = false;
  constructor(private configService: ConfigService) {
    const apiKey = this.configService.get<string>('SENDGRID_API_KEY');
    if (!apiKey) {
      this.logger.warn('SENDGRID_API_KEY not set — emails will be disabled');
      this.enabled = false;
    } else {
      sgMail.setApiKey(apiKey);
      this.enabled = true;
    }
  }

  async sendForgotPassword(email: string, resetLink: string): Promise<{ sent: boolean; error?: string; resetLink?: string }> {
    if (!this.enabled) {
      this.logger.warn(`SendGrid disabled — skipping forgot-password email to ${email}`);
      return { sent: false, resetLink };
    }

    const from = this.configService.get<string>('SENDGRID_FROM_EMAIL');
    if (!from) {
      this.logger.error('SENDGRID_FROM_EMAIL is not configured');
      throw new Error('SENDGRID_FROM_EMAIL is not configured');
    }

    const templateId = this.configService.get<string>('SENDGRID_TEMPLATE_ID');

    if (templateId) {
      const msg: any = {
        to: email,
        from,
        templateId,
        dynamic_template_data: {
          reset_link: resetLink,
        },
      };
      try {
        await sgMail.send(msg);
        return { sent: true };
      } catch (error: any) {
        const body = error?.response?.body ? JSON.stringify(error.response.body) : undefined;
        const errMsg = error?.message ?? body ?? 'Unknown sendgrid error';
        this.logger.error('SendGrid send error (template): ' + (body ?? errMsg));
        // return failure to caller so it can decide to expose the reset link in dev
        return { sent: false, error: errMsg, resetLink };
      }
    }

    // fallback to a simple plaintext/html email if no template id is configured
    const plainMsg: any = {
      to: email,
      from,
      subject: 'Restablece tu contraseña',
      text: `Accede al siguiente enlace para restablecer tu contraseña: ${resetLink}`,
      html: `<p>Accede al siguiente enlace para restablecer tu contraseña:</p><p><a href="${resetLink}">${resetLink}</a></p>`,
    };

    try {
      await sgMail.send(plainMsg);
      return { sent: true };
    } catch (error: any) {
      const body = error?.response?.body ? JSON.stringify(error.response.body) : undefined;
      const errMsg = error?.message ?? body ?? 'Unknown sendgrid error';
      this.logger.error('SendGrid send error (plain): ' + (body ?? errMsg));
      return { sent: false, error: errMsg, resetLink };
    }
  }
}
