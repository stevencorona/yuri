CREATE TABLE `Accounts` (
  `AccountId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `AccountEmail` varchar(255) NOT NULL DEFAULT '',
  `AccountPassword` varchar(255) NOT NULL,
  `AccountKanBalance` int(10) NOT NULL DEFAULT '0',
  `AccountBanned` int(10) unsigned NOT NULL DEFAULT '0',
  `AccountCharId1` int(10) unsigned DEFAULT NULL,
  `AccountCharId2` int(10) unsigned DEFAULT NULL,
  `AccountCharId3` int(10) unsigned DEFAULT NULL,
  `AccountCharId4` int(10) unsigned DEFAULT NULL,
  `AccountCharId5` int(10) unsigned DEFAULT NULL,
  `AccountCharId6` int(10) unsigned DEFAULT NULL,
  `AccountConfirm` varchar(255) NOT NULL DEFAULT '',
  `AccountActivated` int(10) unsigned NOT NULL DEFAULT '0',
  `AccountTempPassword` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`AccountId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `AdminPassword` (
  `AdmId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `AdmActId` int(10) unsigned NOT NULL DEFAULT '0',
  `AdmPassword` varchar(255) NOT NULL DEFAULT '',
  `AdmTimer` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`AdmId`),
  KEY `AdmActId` (`AdmActId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Aethers` (
  `AthId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `AthChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `AthSplId` int(10) unsigned NOT NULL DEFAULT '0',
  `AthDuration` int(10) unsigned NOT NULL DEFAULT '0',
  `AthAether` int(10) unsigned NOT NULL DEFAULT '0',
  `AthPosition` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`AthId`),
  KEY `AthSplId` (`AthSplId`),
  KEY `AthChaId` (`AthChaId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `AuctionBids` (
  `AuctionBidId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `AuctionId` int(10) unsigned NOT NULL,
  `AuctionChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `AuctionItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `AuctionBidAmount` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`AuctionBidId`),
  KEY `EqpChaId` (`AuctionChaId`) USING BTREE,
  KEY `EqpItmId` (`AuctionItmId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Auctions` (
  `AuctionId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `AuctionExpireTimer` int(10) unsigned NOT NULL DEFAULT '0',
  `AuctionChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `AuctionPrice` int(10) unsigned NOT NULL DEFAULT '0',
  `AuctionBidding` tinyint(10) unsigned NOT NULL DEFAULT '0',
  `AuctionItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `AuctionItmAmount` int(10) unsigned NOT NULL DEFAULT '1',
  `AuctionItmDurability` int(10) unsigned NOT NULL DEFAULT '0',
  `AuctionItmEngrave` varchar(64) NOT NULL DEFAULT '',
  `AuctionItmTimer` int(10) unsigned NOT NULL DEFAULT '0',
  `AuctionItmCustomLook` int(10) unsigned NOT NULL DEFAULT '0',
  `AuctionItmCustomLookColor` int(10) unsigned NOT NULL DEFAULT '0',
  `AuctionItmCustomIcon` int(10) unsigned NOT NULL DEFAULT '0',
  `AuctionItmCustomIconColor` int(10) unsigned NOT NULL DEFAULT '0',
  `AuctionItmProtected` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`AuctionId`),
  KEY `EqpChaId` (`AuctionChaId`) USING BTREE,
  KEY `EqpItmId` (`AuctionItmId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Authorize` (
  `AutId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `AutChaId` int(11) unsigned NOT NULL DEFAULT '0',
  `AutChaName` varchar(16) NOT NULL DEFAULT '',
  `AutIP` int(11) unsigned NOT NULL DEFAULT '0',
  `AutTimer` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`AutId`),
  KEY `AutChaName` (`AutChaName`),
  KEY `AutChaId` (`AutChaId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Banks` (
  `BnkId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `BnkChaId` int(11) unsigned NOT NULL DEFAULT '0',
  `BnkItmId` int(11) unsigned NOT NULL DEFAULT '0',
  `BnkDura` int(10) unsigned NOT NULL DEFAULT '0',
  `BnkAmount` int(11) unsigned NOT NULL DEFAULT '0',
  `BnkChaIdOwner` int(11) unsigned NOT NULL DEFAULT '0',
  `BnkEngrave` varchar(64) NOT NULL DEFAULT '0',
  `BnkTimer` int(11) unsigned NOT NULL DEFAULT '0',
  `BnkPosition` int(11) unsigned NOT NULL DEFAULT '0',
  `BnkCustom` int(10) unsigned NOT NULL DEFAULT '0',
  `BnkCustomLook` int(10) unsigned NOT NULL DEFAULT '0',
  `BnkCustomLookColor` int(10) unsigned NOT NULL DEFAULT '0',
  `BnkCustomIcon` int(10) unsigned NOT NULL DEFAULT '0',
  `BnkCustomIconColor` int(10) unsigned NOT NULL DEFAULT '0',
  `BnkProtected` int(10) unsigned NOT NULL DEFAULT '0',
  `BnkNote` varchar(300) NOT NULL DEFAULT '',
  PRIMARY KEY (`BnkId`),
  KEY `BnkChaId` (`BnkChaId`),
  KEY `BnkItmId` (`BnkItmId`)
  
  CREATE TABLE `BannedIP` (
  `BndId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `BndIP` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`BndId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `BoardLocations` (
  `BrdId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `BoardId` int(10) unsigned NOT NULL DEFAULT '0',
  `BoardM` int(10) NOT NULL,
  `BoardX` int(10) NOT NULL,
  `BoardY` int(10) NOT NULL,
  PRIMARY KEY (`BrdId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `BoardNames` (
  `BnmId` int(10) unsigned NOT NULL DEFAULT '0',
  `BnmIdentifier` varchar(64) NOT NULL DEFAULT '',
  `BnmDescription` varchar(64) NOT NULL DEFAULT '',
  `BnmLevel` int(10) unsigned NOT NULL DEFAULT '0',
  `BnmGMLevel` int(10) unsigned NOT NULL DEFAULT '0',
  `BnmPthId` int(10) unsigned NOT NULL DEFAULT '0',
  `BnmClnId` int(10) unsigned NOT NULL DEFAULT '0',
  `BnmScripted` int(10) unsigned NOT NULL DEFAULT '0',
  `BnmSortOrder` int(10) unsigned NOT NULL DEFAULT '256',
  PRIMARY KEY (`BnmId`),
  KEY `BnmClnId` (`BnmClnId`),
  KEY `BnmPthId` (`BnmPthId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Boards` (
  `BrdId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `BrdBnmId` int(10) unsigned NOT NULL DEFAULT '0',
  `BrdChaName` varchar(16) NOT NULL DEFAULT '',
  `BrdChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `BrdBtlId` int(10) unsigned NOT NULL DEFAULT '0',
  `BrdHighlighted` int(11) NOT NULL DEFAULT '0',
  `BrdMonth` int(10) unsigned NOT NULL DEFAULT '0',
  `BrdDay` int(10) unsigned NOT NULL DEFAULT '0',
  `BrdTopic` varchar(255) NOT NULL DEFAULT '',
  `BrdPost` text NOT NULL,
  `BrdPosition` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`BrdId`),
  KEY `BrdBnmId` (`BrdBnmId`),
  KEY `BrdChaName` (`BrdChaName`),
  KEY `BrdBtlId` (`BrdBtlId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `BoardTitles` (
  `BtlId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `BtlDescription` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`BtlId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `BotCheckAttempts` (
  `BotCheckId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `BotCheckTimeDate` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `BotCheckCharName` varchar(255) DEFAULT '',
  `BotCheckIP` varchar(255) NOT NULL DEFAULT '',
  `BotCheckInput` varchar(255) NOT NULL DEFAULT '',
  `BotCheckKey` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`BotCheckId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Character` (
  `ChaId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ChaName` varchar(16) NOT NULL DEFAULT '',
  `ChaPassword` varchar(32) NOT NULL DEFAULT '',
  `ChaOnline` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaBanned` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaLastIP` varchar(255) NOT NULL DEFAULT '',
  `ChaClnId` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaClnRank` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaClanTitle` varchar(32) NOT NULL DEFAULT '',
  `ChaTitle` varchar(32) NOT NULL DEFAULT '',
  `ChaLevel` int(10) unsigned NOT NULL DEFAULT '1',
  `ChaPthId` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaPthRank` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaMark` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaTier` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaTotem` int(10) unsigned NOT NULL DEFAULT '4',
  `ChaKarma` float(10,6) NOT NULL DEFAULT '0.000000',
  `ChaCurrentVita` int(10) unsigned NOT NULL DEFAULT '100',
  `ChaBaseVita` int(10) unsigned NOT NULL DEFAULT '100',
  `ChaCurrentMana` int(10) unsigned NOT NULL DEFAULT '50',
  `ChaBaseMana` int(10) unsigned NOT NULL DEFAULT '50',
  `ChaExperience` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaGold` int(10) unsigned NOT NULL DEFAULT '100',
  `ChaSex` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaNation` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaFace` int(10) unsigned NOT NULL DEFAULT '200',
  `ChaFaceColor` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaHair` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaHairColor` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaSkinColor` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaArmorColor` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaServer` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaMapId` int(10) unsigned NOT NULL DEFAULT '50',
  `ChaX` int(10) unsigned NOT NULL DEFAULT '8',
  `ChaY` int(10) unsigned NOT NULL DEFAULT '5',
  `ChaSide` int(10) unsigned NOT NULL DEFAULT '2',
  `ChaState` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaClanChat` int(10) unsigned NOT NULL DEFAULT '1',
  `ChaPathChat` int(10) unsigned NOT NULL DEFAULT '1',
  `ChaNoviceChat` int(10) unsigned NOT NULL DEFAULT '1',
  `ChaTradeChat` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaSettings` int(10) unsigned NOT NULL DEFAULT '12605',
  `ChaGMLevel` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaF1Name` varchar(16) NOT NULL DEFAULT '',
  `ChaDisguise` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaDisguiseColor` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaPK` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaKilledBy` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaKillsPK` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaPKDuration` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaMuted` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaHeroes` int(10) unsigned NOT NULL DEFAULT '1',
  `ChaMaximumInventory` int(10) unsigned NOT NULL DEFAULT '27',
  `ChaMaximumBankSlots` int(10) unsigned NOT NULL DEFAULT '15',
  `ChaBankGold` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaExperienceSoldMagic` bigint(20) unsigned NOT NULL DEFAULT '0',
  `ChaExperienceSoldHealth` bigint(20) unsigned NOT NULL DEFAULT '0',
  `ChaExperienceSoldStats` bigint(20) unsigned NOT NULL DEFAULT '0',
  `ChaBaseMight` int(10) unsigned NOT NULL DEFAULT '3',
  `ChaBaseWill` int(10) unsigned NOT NULL DEFAULT '3',
  `ChaBaseGrace` int(10) unsigned NOT NULL DEFAULT '3',
  `ChaBaseArmor` int(10) NOT NULL DEFAULT '99',
  `ChaHunter` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaHunterNote` varchar(40) DEFAULT '',
  `ChaMiniMapToggle` int(10) unsigned NOT NULL DEFAULT '1',
  `ChaAFKMessage` varchar(80) NOT NULL DEFAULT 'I am currently AFK. Please leave a message.',
  `ChaTutor` tinyint(10) unsigned NOT NULL DEFAULT '0',
  `ChaGuide` tinyint(10) unsigned NOT NULL DEFAULT '0',
  `ChaAlignment` tinyint(10) NOT NULL DEFAULT '0',
  `ChaPartner` int(10) unsigned NOT NULL DEFAULT '0',
  `ChaProfileVitaStats` int(10) unsigned NOT NULL DEFAULT '1',
  `ChaProfileEquipList` int(10) unsigned NOT NULL DEFAULT '1',
  `ChaProfileLegends` int(10) unsigned NOT NULL DEFAULT '1',
  `ChaProfileSpells` int(10) unsigned NOT NULL DEFAULT '1',
  `ChaProfileInventory` int(10) unsigned NOT NULL DEFAULT '1',
  `ChaProfileBankItems` int(10) unsigned NOT NULL DEFAULT '1',
  `ChaShowProfile` int(10) unsigned NOT NULL DEFAULT '1',
  `ChaCaptchaKey` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`ChaId`),
  KEY `ChaName` (`ChaName`),
  KEY `ChaClnId` (`ChaClnId`),
  KEY `ChaPthId` (`ChaPthId`),
  KEY `ChaMapId` (`ChaMapId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ClanBanks` (
  `CbkId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `CbkClnId` int(10) unsigned NOT NULL DEFAULT '0',
  `CbkItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `CbkDura` int(10) unsigned NOT NULL DEFAULT '0',
  `CbkAmount` int(10) unsigned NOT NULL DEFAULT '0',
  `CbkChaIdOwner` int(10) unsigned NOT NULL DEFAULT '0',
  `CbkEngrave` varchar(64) NOT NULL DEFAULT '',
  `CbkTimer` int(10) unsigned NOT NULL DEFAULT '0',
  `CbkPosition` int(10) unsigned NOT NULL DEFAULT '0',
  `CbkCustom` int(10) unsigned NOT NULL DEFAULT '0',
  `CbkCustomLook` int(10) unsigned NOT NULL DEFAULT '0',
  `CbkCustomLookColor` int(10) unsigned NOT NULL DEFAULT '0',
  `CbkCustomIcon` int(10) unsigned NOT NULL DEFAULT '0',
  `CbkCustomIconColor` int(10) unsigned NOT NULL DEFAULT '0',
  `CbkProtected` int(10) unsigned NOT NULL DEFAULT '0',
  `CbkNote` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`CbkId`),
  KEY `CbkClnId` (`CbkClnId`),
  KEY `CbkItmId` (`CbkItmId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1

CREATE TABLE `Clans` (
  `ClnId` int(10) unsigned NOT NULL,
  `ClnName` varchar(64) NOT NULL DEFAULT '',
  `ClnBankSlots` int(10) unsigned NOT NULL DEFAULT '50',
  `ClnLevel` int(10) NOT NULL DEFAULT '1',
  `ClnTribute` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ClnId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Equipment` (
  `EqpId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `EqpChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `EqpItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `EqpDurability` int(10) unsigned NOT NULL DEFAULT '0',
  `EqpChaIdOwner` int(10) unsigned NOT NULL DEFAULT '0',
  `EqpEngrave` varchar(64) NOT NULL DEFAULT '',
  `EqpTimer` int(10) unsigned NOT NULL DEFAULT '0',
  `EqpSlot` int(10) unsigned NOT NULL DEFAULT '0',
  `EqpElement` int(10) unsigned NOT NULL DEFAULT '0',
  `EqpCustom` int(10) unsigned NOT NULL DEFAULT '0',
  `EqpCustomLook` int(10) unsigned NOT NULL DEFAULT '0',
  `EqpCustomLookColor` int(10) unsigned NOT NULL DEFAULT '0',
  `EqpCustomIcon` int(10) unsigned NOT NULL DEFAULT '0',
  `EqpCustomIconColor` int(10) unsigned NOT NULL DEFAULT '0',
  `EqpProtected` int(10) unsigned NOT NULL DEFAULT '0',
  `EqpNote` varchar(300) NOT NULL DEFAULT '',
  PRIMARY KEY (`EqpId`),
  KEY `EqpChaId` (`EqpChaId`) USING BTREE,
  KEY `EqpItmId` (`EqpItmId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Friends` (
  `FndId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `FndChaId` int(10) unsigned NOT NULL,
  `FndChaName1` varchar(16) NOT NULL DEFAULT '',
  `FndChaName2` varchar(16) NOT NULL DEFAULT '',
  `FndChaName3` varchar(16) NOT NULL DEFAULT '',
  `FndChaName4` varchar(16) NOT NULL DEFAULT '',
  `FndChaName5` varchar(16) NOT NULL DEFAULT '',
  `FndChaName6` varchar(16) NOT NULL DEFAULT '',
  `FndChaName7` varchar(16) NOT NULL DEFAULT '',
  `FndChaName8` varchar(16) NOT NULL DEFAULT '',
  `FndChaName9` varchar(16) NOT NULL DEFAULT '',
  `FndChaName10` varchar(16) NOT NULL DEFAULT '',
  `FndChaName11` varchar(16) NOT NULL DEFAULT '',
  `FndChaName12` varchar(16) NOT NULL DEFAULT '',
  `FndChaName13` varchar(16) NOT NULL DEFAULT '',
  `FndChaName14` varchar(16) NOT NULL DEFAULT '',
  `FndChaName15` varchar(16) NOT NULL DEFAULT '',
  `FndChaName16` varchar(16) NOT NULL DEFAULT '',
  `FndChaName17` varchar(16) NOT NULL DEFAULT '',
  `FndChaName18` varchar(16) NOT NULL DEFAULT '',
  `FndChaName19` varchar(16) NOT NULL DEFAULT '',
  `FndChaName20` varchar(16) NOT NULL DEFAULT '',
  PRIMARY KEY (`FndId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `GameRegistry0` (
  `GrgId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `GrgIdentifier` varchar(64) NOT NULL DEFAULT '',
  `GrgValue` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`GrgId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Gifts` (
  `GiftId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `GiftItemId1` int(10) unsigned NOT NULL DEFAULT '0',
  `GiftItemEngrave1` varchar(64) NOT NULL DEFAULT '',
  `GiftItemAmount1` int(10) unsigned NOT NULL DEFAULT '0',
  `GiftItemId2` int(10) unsigned NOT NULL DEFAULT '0',
  `GiftItemEngrave2` varchar(64) NOT NULL DEFAULT '',
  `GiftItemAmount2` int(10) unsigned NOT NULL DEFAULT '0',
  `GiftItemId3` int(10) unsigned NOT NULL DEFAULT '0',
  `GiftItemEngrave3` varchar(64) NOT NULL DEFAULT '',
  `GiftItemAmount3` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`GiftId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Inventory` (
  `InvId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `InvChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `InvItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `InvAmount` int(10) unsigned NOT NULL DEFAULT '0',
  `InvDurability` int(10) unsigned NOT NULL DEFAULT '0',
  `InvChaIdOwner` int(10) unsigned NOT NULL DEFAULT '0',
  `InvEngrave` varchar(64) NOT NULL DEFAULT '',
  `InvTimer` int(10) unsigned NOT NULL DEFAULT '0',
  `InvPosition` int(10) unsigned NOT NULL DEFAULT '0',
  `InvElement` int(10) unsigned NOT NULL DEFAULT '0',
  `InvCustom` int(10) unsigned NOT NULL DEFAULT '0',
  `InvCustomLook` int(10) unsigned NOT NULL DEFAULT '0',
  `InvCustomLookColor` int(10) unsigned NOT NULL DEFAULT '0',
  `InvCustomIcon` int(10) unsigned NOT NULL DEFAULT '0',
  `InvCustomIconColor` int(10) unsigned NOT NULL DEFAULT '0',
  `InvProtected` int(10) unsigned NOT NULL DEFAULT '0',
  `InvNote` varchar(300) NOT NULL DEFAULT '',
  PRIMARY KEY (`InvId`),
  KEY `InvChaId` (`InvChaId`) USING BTREE,
  KEY `InvItmId` (`InvItmId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Items` (
  `ItmId` int(10) unsigned NOT NULL,
  `ItmPthId` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmIdentifier` varchar(64) NOT NULL DEFAULT '',
  `ItmDescription` varchar(64) NOT NULL DEFAULT '',
  `ItmType` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmSkinnable` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmStackAmount` int(10) unsigned NOT NULL DEFAULT '1',
  `ItmMaximumAmount` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmLook` int(10) NOT NULL DEFAULT '0',
  `ItmLookColor` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmIcon` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmIconColor` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmSex` int(10) unsigned NOT NULL DEFAULT '2',
  `ItmLevel` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmMark` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmDurability` int(10) unsigned NOT NULL DEFAULT '1000000',
  `ItmMinimumSDamage` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmMaximumSDamage` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmMinimumLDamage` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmMaximumLDamage` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmArmor` int(10) NOT NULL DEFAULT '0',
  `ItmHit` int(10) NOT NULL DEFAULT '0',
  `ItmDam` int(10) NOT NULL DEFAULT '0',
  `ItmVita` int(10) NOT NULL DEFAULT '0',
  `ItmMana` int(10) NOT NULL DEFAULT '0',
  `ItmMight` int(10) NOT NULL DEFAULT '0',
  `ItmWill` int(10) NOT NULL DEFAULT '0',
  `ItmGrace` int(10) NOT NULL DEFAULT '0',
  `ItmProtection` int(10) NOT NULL DEFAULT '0',
  `ItmHealing` int(10) NOT NULL DEFAULT '0',
  `ItmWisdom` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmMightRequired` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmExchangeable` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmDepositable` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmDroppable` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmCon` int(10) NOT NULL DEFAULT '0',
  `ItmSound` int(10) unsigned NOT NULL DEFAULT '331',
  `ItmText` varchar(64) NOT NULL DEFAULT '',
  `ItmBuyPrice` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmSellPrice` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmBuyText` varchar(64) NOT NULL DEFAULT '',
  `ItmThrown` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmThrownConfirm` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmRepairable` int(10) unsigned NOT NULL DEFAULT '1',
  `ItmIndestructible` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmTimer` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmBoD` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmProtected` int(10) NOT NULL DEFAULT '0',
  `ItmUnequip` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ItmId`),
  KEY `ItmPthId` (`ItmPthId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `ItemSets` (
  `ItmId` int(10) unsigned NOT NULL,
  `ItmSetId` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmSetItem1` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmSetItem1Amount` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmSetItem2` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmSetItem2Amount` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmSetItem3` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmSetItem3Amount` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmSetItem4` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmSetItem4Amount` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmSetItem5` int(10) unsigned NOT NULL DEFAULT '0',
  `ItmSetItem5Amount` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ItmId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `KanPoints` (
  `KanPoints` int(10) unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Kills` (
  `KilId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `KilChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `KilMobId` int(10) unsigned NOT NULL DEFAULT '0',
  `KilAmount` int(10) unsigned NOT NULL DEFAULT '0',
  `KilPosition` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`KilId`),
  KEY `KilChaId` (`KilChaId`),
  KEY `KilMobId` (`KilMobId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Legends` (
  `LegId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `LegChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `LegIdentifier` varchar(64) NOT NULL DEFAULT '',
  `LegDescription` varchar(255) NOT NULL DEFAULT '',
  `LegIcon` int(10) unsigned NOT NULL DEFAULT '0',
  `LegColor` int(10) unsigned NOT NULL DEFAULT '0',
  `LegPosition` int(10) unsigned NOT NULL DEFAULT '0',
  `LegTChaId` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`LegId`),
  KEY `LegChaId` (`LegChaId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Mail` (
  `MalId` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `MalChaName` varchar(16) NOT NULL DEFAULT '',
  `MalChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `MalChaNameDestination` varchar(16) NOT NULL DEFAULT '',
  `MalSubject` varchar(52) NOT NULL DEFAULT '',
  `MalBody` varchar(4000) NOT NULL DEFAULT '',
  `MalPosition` int(11) unsigned NOT NULL DEFAULT '0',
  `MalMonth` int(11) unsigned NOT NULL DEFAULT '0',
  `MalDay` int(11) unsigned NOT NULL DEFAULT '0',
  `MalDeleted` int(11) unsigned NOT NULL DEFAULT '0',
  `MalNew` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`MalId`),
  KEY `MalChaName` (`MalChaName`),
  KEY `MalChaNameDestination` (`MalChaNameDestination`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Maintenance` (
  `MaintenanceMode` int(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `MapModifiers` (
  `ModId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ModMapId` int(10) unsigned NOT NULL DEFAULT '0',
  `ModModifier` varchar(255) NOT NULL DEFAULT '',
  `ModValue` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ModId`),
  KEY `MrgMapId` (`ModMapId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `MapRegistry` (
  `MrgId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `MrgMapId` int(10) unsigned NOT NULL DEFAULT '0',
  `MrgIdentifier` varchar(64) NOT NULL DEFAULT '',
  `MrgValue` int(10) unsigned NOT NULL DEFAULT '0',
  `MrgPosition` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`MrgId`),
  KEY `MrgMapId` (`MrgMapId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Maps` (
  `MapId` int(10) unsigned NOT NULL,
  `MapName` varchar(64) NOT NULL DEFAULT 'Test',
  `MapBGM` int(10) unsigned NOT NULL DEFAULT '0',
  `MapBGMType` int(10) unsigned NOT NULL DEFAULT '1',
  `MapPvP` int(10) unsigned NOT NULL DEFAULT '0',
  `MapSpells` int(10) unsigned NOT NULL DEFAULT '1',
  `MapLight` int(10) unsigned NOT NULL DEFAULT '0',
  `MapWeather` int(10) unsigned NOT NULL DEFAULT '0',
  `MapSweepTime` int(10) unsigned NOT NULL DEFAULT '7200000',
  `MapChat` int(10) unsigned NOT NULL DEFAULT '0',
  `MapGhosts` int(10) unsigned NOT NULL DEFAULT '0',
  `MapRegion` int(10) unsigned NOT NULL DEFAULT '0',
  `MapIndoor` int(10) unsigned NOT NULL DEFAULT '0',
  `MapWarpout` int(10) unsigned NOT NULL DEFAULT '0',
  `MapBind` int(10) unsigned NOT NULL DEFAULT '0',
  `MapFile` varchar(1024) NOT NULL DEFAULT 'spell_test_zone.map',
  `MapServer` int(10) unsigned NOT NULL DEFAULT '0',
  `MapReqLvl` int(10) NOT NULL DEFAULT '0',
  `MapReqPath` int(10) unsigned NOT NULL DEFAULT '0',
  `MapReqMark` int(10) unsigned NOT NULL DEFAULT '0',
  `MapReqVita` int(10) unsigned NOT NULL DEFAULT '0',
  `MapReqMana` int(10) unsigned NOT NULL DEFAULT '0',
  `MapLvlMax` int(10) unsigned NOT NULL DEFAULT '99',
  `MapVitaMax` int(10) unsigned NOT NULL DEFAULT '0',
  `MapManaMax` int(10) unsigned NOT NULL DEFAULT '0',
  `MapRejectMsg` varchar(64) NOT NULL DEFAULT '',
  `MapCanSummon` int(10) unsigned NOT NULL DEFAULT '1',
  `MapCanUse` int(10) unsigned NOT NULL DEFAULT '1',
  `MapCanEat` int(10) unsigned NOT NULL DEFAULT '1',
  `MapCanSmoke` int(10) unsigned NOT NULL DEFAULT '1',
  `MapCanMount` int(10) unsigned NOT NULL DEFAULT '1',
  `MapCanGroup` int(10) unsigned NOT NULL DEFAULT '1',
  `MapCanEquip` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`MapId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `MobEquipment` (
  `MeqId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `MeqMobId` int(10) unsigned NOT NULL DEFAULT '0',
  `MeqLook` int(10) unsigned NOT NULL DEFAULT '0',
  `MeqColor` int(10) unsigned NOT NULL DEFAULT '0',
  `MeqSlot` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`MeqId`),
  KEY `MeqMobId` (`MeqMobId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Mobs` (
  `MobId` int(10) unsigned NOT NULL,
  `MobIdentifier` varchar(45) NOT NULL DEFAULT '',
  `MobDescription` varchar(45) NOT NULL DEFAULT '',
  `MobBehavior` int(10) unsigned NOT NULL DEFAULT '0',
  `MobAI` int(10) unsigned NOT NULL DEFAULT '0',
  `MobIsBoss` int(10) unsigned NOT NULL DEFAULT '0',
  `MobIsChar` int(10) unsigned NOT NULL DEFAULT '0',
  `MobIsNpc` int(10) unsigned NOT NULL DEFAULT '0',
  `MobLook` int(10) unsigned NOT NULL DEFAULT '0',
  `MobLookColor` int(10) unsigned NOT NULL DEFAULT '0',
  `MobVita` int(10) unsigned NOT NULL DEFAULT '0',
  `MobMana` int(10) unsigned NOT NULL DEFAULT '0',
  `MobExperience` int(10) unsigned NOT NULL DEFAULT '0',
  `MobHit` int(10) unsigned NOT NULL DEFAULT '0',
  `MobDam` int(10) unsigned NOT NULL DEFAULT '0',
  `MobLevel` int(10) unsigned NOT NULL DEFAULT '0',
  `MobMark` int(10) unsigned NOT NULL DEFAULT '0',
  `MobMinimumDamage` int(10) unsigned NOT NULL DEFAULT '0',
  `MobMaximumDamage` int(10) unsigned NOT NULL DEFAULT '0',
  `MobMoveTime` int(10) unsigned NOT NULL DEFAULT '2000',
  `MobAttackTime` int(10) unsigned NOT NULL DEFAULT '2000',
  `MobSpawnTime` int(10) unsigned NOT NULL DEFAULT '180',
  `MobMight` int(10) unsigned NOT NULL DEFAULT '0',
  `MobGrace` int(10) unsigned NOT NULL DEFAULT '0',
  `MobWill` int(10) unsigned NOT NULL DEFAULT '0',
  `MobWisdom` int(10) unsigned NOT NULL DEFAULT '0',
  `MobCon` int(10) unsigned NOT NULL DEFAULT '0',
  `MobProtection` int(10) unsigned NOT NULL DEFAULT '0',
  `MobArmor` int(10) NOT NULL DEFAULT '0',
  `MobSound` int(10) unsigned NOT NULL DEFAULT '0',
  `MobReturnDistance` int(10) unsigned NOT NULL DEFAULT '0',
  `MobSex` int(10) unsigned NOT NULL DEFAULT '0',
  `MobFace` int(10) unsigned NOT NULL DEFAULT '0',
  `MobFaceColor` int(10) unsigned NOT NULL DEFAULT '0',
  `MobHair` int(10) unsigned NOT NULL DEFAULT '0',
  `MobHairColor` int(10) unsigned NOT NULL DEFAULT '0',
  `MobSkinColor` int(10) unsigned NOT NULL DEFAULT '0',
  `MobState` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`MobId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `NPCEquipment0` (
  `NeqId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `NeqNpcId` int(10) unsigned NOT NULL DEFAULT '0',
  `NeqLook` int(10) unsigned NOT NULL DEFAULT '0',
  `NeqColor` int(10) unsigned NOT NULL DEFAULT '0',
  `NeqSlot` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`NeqId`),
  KEY `NeqNpcId` (`NeqNpcId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `NPCRegistry` (
  `NrgId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `NrgChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `NrgIdentifier` varchar(64) NOT NULL DEFAULT '',
  `NrgValue` int(10) unsigned NOT NULL DEFAULT '0',
  `NrgPosition` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`NrgId`),
  KEY `NrgChaId` (`NrgChaId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `NPCs0` (
  `NpcId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `NpcIdentifier` varchar(64) NOT NULL DEFAULT '',
  `NpcDescription` varchar(64) NOT NULL DEFAULT '',
  `NpcType` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcMapId` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcX` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcY` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcTimer` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcLook` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcLookColor` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcSex` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcSide` int(10) unsigned NOT NULL DEFAULT '2',
  `NpcState` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcFace` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcFaceColor` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcHair` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcHairColor` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcSkinColor` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcIsChar` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcIsF1Npc` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcIsRepairNpc` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcIsShopNpc` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcIsBankNpc` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcReturnDistance` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcMoveTime` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcCanReceiveItem` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`NpcId`),
  KEY `NpcMapId` (`NpcMapId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Parcels` (
  `ParId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ParSender` int(10) unsigned NOT NULL DEFAULT '0',
  `ParChaIdDestination` int(10) unsigned NOT NULL DEFAULT '0',
  `ParItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `ParItmDura` int(10) unsigned NOT NULL DEFAULT '0',
  `ParAmount` int(10) unsigned NOT NULL DEFAULT '0',
  `ParChaIdOwner` int(10) unsigned NOT NULL DEFAULT '0',
  `ParEngrave` varchar(32) NOT NULL DEFAULT '',
  `ParNpc` int(10) unsigned NOT NULL DEFAULT '0',
  `ParPosition` int(10) unsigned NOT NULL DEFAULT '0',
  `ParCustomLook` int(10) unsigned NOT NULL DEFAULT '0',
  `ParCustomLookColor` int(10) unsigned NOT NULL DEFAULT '0',
  `ParCustomIcon` int(10) unsigned NOT NULL DEFAULT '0',
  `ParCustomIconColor` int(10) unsigned NOT NULL DEFAULT '0',
  `ParProtected` int(10) unsigned NOT NULL DEFAULT '0',
  `ParNote` varchar(300) NOT NULL DEFAULT '',
  PRIMARY KEY (`ParId`),
  KEY `ParChaIdDestination` (`ParChaIdDestination`),
  KEY `ParItmId` (`ParItmId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE TABLE `Paths` (
  `PthId` int(10) unsigned NOT NULL,
  `PthType` int(10) unsigned NOT NULL DEFAULT '0',
  `PthChat` int(10) unsigned NOT NULL DEFAULT '0',
  `PthIcon` int(10) unsigned NOT NULL DEFAULT '0',
  `PthMark0` varchar(32) NOT NULL DEFAULT '',
  `PthMark1` varchar(32) NOT NULL DEFAULT '',
  `PthMark2` varchar(32) NOT NULL DEFAULT '',
  `PthMark3` varchar(32) NOT NULL DEFAULT '',
  `PthMark4` varchar(32) NOT NULL DEFAULT '',
  `PthMark5` varchar(32) NOT NULL DEFAULT '',
  `PthMark6` varchar(32) NOT NULL DEFAULT '',
  `PthMark7` varchar(32) NOT NULL DEFAULT '',
  `PthMark8` varchar(32) NOT NULL DEFAULT '',
  `PthMark9` varchar(32) NOT NULL DEFAULT '',
  `PthMark10` varchar(32) NOT NULL DEFAULT '',
  `PthMark11` varchar(32) NOT NULL DEFAULT '',
  `PthMark12` varchar(32) NOT NULL DEFAULT '',
  `PthMark13` varchar(32) NOT NULL DEFAULT '',
  `PthMark14` varchar(32) NOT NULL DEFAULT '',
  `PthMark15` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`PthId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `QuestRegistry` (
  `QrgId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `QrgChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `QrgIdentifier` varchar(64) NOT NULL DEFAULT '',
  `QrgValue` int(10) unsigned NOT NULL DEFAULT '0',
  `QrgPosition` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`QrgId`),
  KEY `QrgChaId` (`QrgChaId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `RankingEvents` (
  `EventId` int(10) NOT NULL AUTO_INCREMENT,
  `EventName` varchar(40) NOT NULL,
  `FromDate` int(10) NOT NULL DEFAULT '0',
  `FromTime` int(10) NOT NULL DEFAULT '0',
  `ToDate` int(10) NOT NULL DEFAULT '0',
  `ToTime` int(10) NOT NULL DEFAULT '0',
  `EventRewardRanks_Display` int(10) NOT NULL DEFAULT '3',
  `EventLegend` varchar(16) NOT NULL,
  `EventLegendIcon1` int(10) NOT NULL DEFAULT '0',
  `EventLegendIcon1Color` int(10) NOT NULL DEFAULT '1',
  `EventLegendIcon2` int(10) NOT NULL DEFAULT '0',
  `EventLegendIcon2Color` int(10) NOT NULL DEFAULT '1',
  `EventLegendIcon3` int(10) NOT NULL DEFAULT '0',
  `EventLegendIcon3Color` int(10) NOT NULL DEFAULT '1',
  `EventLegendIcon4` int(10) NOT NULL DEFAULT '0',
  `EventLegendIcon4Color` int(10) NOT NULL DEFAULT '0',
  `EventLegendIcon5` int(10) NOT NULL DEFAULT '0',
  `EventLegendIcon5Color` int(10) NOT NULL DEFAULT '0',
  `1stPlaceReward1_ItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `1stPlaceReward1_Amount` int(10) unsigned NOT NULL DEFAULT '0',
  `1stPlaceReward2_ItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `1stPlaceReward2_Amount` int(10) unsigned NOT NULL DEFAULT '0',
  `2ndPlaceReward1_ItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `2ndPlaceReward1_Amount` int(10) unsigned NOT NULL DEFAULT '0',
  `2ndPlaceReward2_ItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `2ndPlaceReward2_Amount` int(10) unsigned NOT NULL DEFAULT '0',
  `3rdPlaceReward1_ItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `3rdPlaceReward1_Amount` int(10) unsigned NOT NULL DEFAULT '0',
  `3rdPlaceReward2_ItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `3rdPlaceReward2_Amount` int(10) unsigned NOT NULL DEFAULT '0',
  `4thPlaceReward1_ItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `4thPlaceReward1_Amount` int(10) unsigned NOT NULL DEFAULT '0',
  `4thPlaceReward2_ItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `4thPlaceReward2_Amount` int(10) unsigned NOT NULL DEFAULT '0',
  `5thPlaceReward1_ItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `5thPlaceReward1_Amount` int(10) unsigned NOT NULL DEFAULT '0',
  `5thPlaceReward2_ItmId` int(10) unsigned NOT NULL DEFAULT '0',
  `5thPlaceReward2_Amount` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`EventId`),
  KEY `REventId` (`EventId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `RankingScores` (
  `Index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `EventId` int(10) NOT NULL DEFAULT '0',
  `ChaId` int(10) NOT NULL DEFAULT '0',
  `ChaName` varchar(16) NOT NULL,
  `Rank` int(10) NOT NULL DEFAULT '0',
  `Score` int(10) NOT NULL DEFAULT '0',
  `EventClaim` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Index`),
  KEY `EventID` (`EventId`),
  KEY `ChaId` (`ChaId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Recipes` (
  `RecId` int(11) NOT NULL DEFAULT '0',
  `RecIdentifier` varchar(64) NOT NULL DEFAULT '',
  `RecDescription` varchar(64) NOT NULL DEFAULT '',
  `RecCritIdentifier` varchar(64) NOT NULL DEFAULT '',
  `RecCritDescription` varchar(64) NOT NULL DEFAULT '',
  `RecCraftTime` int(10) unsigned NOT NULL DEFAULT '0',
  `RecSuccessRate` int(10) unsigned NOT NULL DEFAULT '0',
  `RecSkillAdvance` int(10) unsigned NOT NULL DEFAULT '0',
  `RecCritRate` int(10) unsigned NOT NULL DEFAULT '0',
  `RecBonus` int(10) unsigned NOT NULL DEFAULT '0',
  `RecSkillRequired` int(10) unsigned NOT NULL DEFAULT '0',
  `RecTokensRequired` int(11) NOT NULL DEFAULT '0',
  `RecMaterial1` int(11) NOT NULL DEFAULT '0',
  `RecAmount1` int(11) NOT NULL DEFAULT '0',
  `RecMaterial2` int(11) NOT NULL DEFAULT '0',
  `RecAmount2` int(11) NOT NULL DEFAULT '0',
  `RecMaterial3` int(11) NOT NULL DEFAULT '0',
  `RecAmount3` int(11) NOT NULL DEFAULT '0',
  `RecMaterial4` int(11) NOT NULL DEFAULT '0',
  `RecAmount4` int(11) NOT NULL DEFAULT '0',
  `RecMaterial5` int(11) NOT NULL DEFAULT '0',
  `RecAmount5` int(11) NOT NULL DEFAULT '0',
  `RecSuperiorMaterial1` int(11) NOT NULL DEFAULT '0',
  `RecSuperiorAmount1` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`RecId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Registry` (
  `RegId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `RegChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `RegIdentifier` varchar(64) NOT NULL DEFAULT '',
  `RegValue` int(10) unsigned NOT NULL DEFAULT '0',
  `RegPosition` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`RegId`),
  KEY `RegChaId` (`RegChaId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `RegistryString` (
  `RegId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `RegChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `RegIdentifier` varchar(64) NOT NULL DEFAULT '',
  `RegValue` varchar(255) NOT NULL DEFAULT '',
  `RegPosition` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`RegId`),
  KEY `RegChaId` (`RegChaId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Spawns0` (
  `SpnId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `SpnMobId` int(10) unsigned NOT NULL DEFAULT '0',
  `SpnMapId` int(10) unsigned NOT NULL DEFAULT '0',
  `SpnX` int(10) unsigned NOT NULL DEFAULT '0',
  `SpnY` int(10) unsigned NOT NULL DEFAULT '0',
  `SpnLastDeath` int(10) unsigned NOT NULL DEFAULT '0',
  `SpnStartTime` int(10) unsigned NOT NULL DEFAULT '25',
  `SpnEndTime` int(10) unsigned NOT NULL DEFAULT '25',
  `SpnMobIdReplace` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`SpnId`),
  KEY `SpnMobId` (`SpnMobId`),
  KEY `SpnMapId` (`SpnMapId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `SpellBook` (
  `SbkId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `SbkChaId` int(10) unsigned NOT NULL DEFAULT '0',
  `SbkSplId` int(10) unsigned NOT NULL DEFAULT '0',
  `SbkPosition` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`SbkId`),
  KEY `SbkChaId` (`SbkChaId`),
  KEY `SbkSplId` (`SbkSplId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Spells` (
  `SplId` int(10) unsigned NOT NULL,
  `SplIdentifier` varchar(32) NOT NULL DEFAULT '',
  `SplDescription` varchar(32) NOT NULL DEFAULT '',
  `SplType` int(10) unsigned NOT NULL DEFAULT '5',
  `SplPthId` int(10) NOT NULL DEFAULT '5',
  `SplAlignment` tinyint(10) NOT NULL DEFAULT '-1',
  `SplMark` int(10) unsigned NOT NULL DEFAULT '0',
  `SplLevel` int(10) unsigned NOT NULL DEFAULT '0',
  `SplQuestion` varchar(64) NOT NULL DEFAULT '',
  `SplDispel` int(10) unsigned NOT NULL DEFAULT '0',
  `SplAether` int(10) unsigned NOT NULL DEFAULT '0',
  `SplMute` int(10) unsigned NOT NULL DEFAULT '0',
  `SplActive` int(10) unsigned NOT NULL DEFAULT '1',
  `SplCanFail` int(10) unsigned NOT NULL DEFAULT '1',
  `SplTicker` int(10) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`SplId`),
  KEY `SplPthId` (`SplPthId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Time` (
  `TimId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `TimHour` int(10) unsigned NOT NULL DEFAULT '0',
  `TimDay` int(10) unsigned NOT NULL DEFAULT '0',
  `TimSeason` int(10) unsigned NOT NULL DEFAULT '0',
  `TimYear` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`TimId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `Warps` (
  `WarpId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `SourceMapId` int(10) NOT NULL DEFAULT '0',
  `SourceX` int(10) NOT NULL DEFAULT '0',
  `SourceY` int(10) NOT NULL DEFAULT '0',
  `DestinationMapId` int(10) NOT NULL DEFAULT '0',
  `DestinationX` int(10) NOT NULL DEFAULT '0',
  `DestinationY` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`WarpId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `WisdomStar` (
  `WSMultiplier` float(10,6) NOT NULL DEFAULT '0.000000'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;