const cds = require("@sap/cds");

class CosmicService extends cds.ApplicationService {
  init() {
    const validateSpacefarerData = (req) => {
      const data = req.data;

      const wormholeSkillThreshold = 0;
      const stardustCollectionThreshold = 0;

      if (data.wormholeNavigationSkill < wormholeSkillThreshold) {
        req.reject(
          400,
          `Wormhole navigation skill must be above ${wormholeSkillThreshold}`,
        );
      }
      if (data.stardustCollection < stardustCollectionThreshold) {
        req.reject(
          400,
          `Stardust collection must be above ${stardustCollectionThreshold}`,
        );
      }
    };

    const enhanceSpacefarerData = (data) => {
      const wormholeSkillEnhancement = 5;
      const stardustCollectionEnhancement = 5;

      data.wormholeNavigationSkill += wormholeSkillEnhancement;
      data.stardustCollection += stardustCollectionEnhancement;
    };

    const sendWelcomeEmail = (spacefarer) => {
      console.log("📧 Sending welcome email...");
      console.log("═══════════════════════════════════════");
      console.log(`  To: spacefarer-${spacefarer.name}@galaxy.com`);
      console.log(`  Subject: Welcome to the Cosmic Fleet!`);
      console.log(`  Body:`);
      console.log(`    Dear Spacefarer,`);
      console.log(`    Congratulations on starting your journey!`);
      console.log(
        `    Your stardust collection: ${spacefarer.stardustCollection}`,
      );
      console.log(
        `    Your wormhole navigation skill: ${spacefarer.wormholeNavigationSkill}`,
      );
      console.log(`    Safe travels among the stars! 🚀`);
      console.log("═══════════════════════════════════════");
    };

    this.before("CREATE", "Spacefarers", (req) => {
      validateSpacefarerData(req);
      enhanceSpacefarerData(req.data);
    });

    this.after("CREATE", "Spacefarers", (result) => {
      // Simulated email sending
      sendWelcomeEmail(result);
    });

    return super.init();
  }
}

module.exports = { CosmicService };
