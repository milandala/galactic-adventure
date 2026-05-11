const cds = require("@sap/cds");
const { sendWelcomeEmail } = require("./email-service");

class CosmicService extends cds.ApplicationService {
  init() {
    const validateSpacefarerData = (req) => {
      const data = req.data;

      const wormholeSkillThreshold = 0;
      const stardustCollectionThreshold = 0;

      let errorList = [];

      if (typeof data.wormholeNavigationSkill !== "number") {
        errorList.push("Wormhole navigation skill must be a number");
      }

      if (typeof data.stardustCollection !== "number") {
        errorList.push("Stardust collection must be a number");
      }

      if (typeof data.originPlanet_code !== "string") {
        errorList.push("Origin planet code must be a string");
      }

      if (data.wormholeNavigationSkill < wormholeSkillThreshold) {
        errorList.push(
          `Wormhole navigation skill must be above ${wormholeSkillThreshold}`,
        );
      }

      if (data.stardustCollection < stardustCollectionThreshold) {
        errorList.push(
          `Stardust collection must be above ${stardustCollectionThreshold}`,
        );
      }

      if (req.data.originPlanet_code !== req.user.attr.planetCode) {
        errorList.push("Origin planet code does not match user's planet code");
      }

      if (errorList.length > 0) {
        req.reject(400, errorList.join("\n\n"));
      }
    };

    const enhanceSpacefarerData = (data) => {
      const wormholeSkillEnhancement = 5;
      const stardustCollectionEnhancement = 5;

      data.wormholeNavigationSkill += wormholeSkillEnhancement;
      data.stardustCollection += stardustCollectionEnhancement;
    };

    this.before("CREATE", "Spacefarers", (req) => {
      validateSpacefarerData(req);
      enhanceSpacefarerData(req.data);
    });

    this.before("CREATE", "Spacefarers.drafts", (req) => {
      req.data.originPlanet_code = req.user.attr.planetCode;
    });

    this.before("UPDATE", "Spacefarers", (req) => {
      validateSpacefarerData(req);
    });

    this.after("CREATE", "Spacefarers", (result) => {
      sendWelcomeEmail(result);
    });

    return super.init();
  }
}

module.exports = { CosmicService };
