const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT || 587,
  secure: false,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
  },
});

const sendWelcomeEmail = async (spacefarer) => {
  await transporter.sendMail({
    from: '"Cosmic Fleet" <noreply@galaxy.com>',
    to: `spacefarer-${spacefarer.name}@galaxy.com`,
    subject: "Welcome to the Cosmic Fleet!",
    html: `
            <h1>Dear Spacefarer,</h1>
            <p>Congratulations on starting your journey!</p>
            <p>Your stardust collection: <strong>${spacefarer.stardustCollection}</strong></p>
            <p>Your wormhole navigation skill: <strong>${spacefarer.wormholeNavigationSkill}</strong></p>
            <p>Safe travels among the stars! 🚀</p>
        `,
  });
};

module.exports = { sendWelcomeEmail };
