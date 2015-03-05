# ---------------------------------------------------------------------- #
# Script generated with: DeZign for Databases v6.3.4                     #
# Target DBMS:           MySQL 5                                         #
# Project file:          reindexer.dez                                   #
# Project name:                                                          #
# Author:                                                                #
# Script type:           Database drop script                            #
# Created on:            2014-11-06 14:01                                #
# ---------------------------------------------------------------------- #


# ---------------------------------------------------------------------- #
# Drop foreign key constraints                                           #
# ---------------------------------------------------------------------- #

ALTER TABLE `externalData` DROP FOREIGN KEY `externalSource_externalData`;

ALTER TABLE `marcMap` DROP FOREIGN KEY `externalSource_marcMap`;

ALTER TABLE `externalFormats` DROP FOREIGN KEY `externalData_externalFormats`;

ALTER TABLE `externalFormats` DROP FOREIGN KEY `Format_externalFormats`;

ALTER TABLE `Format` DROP FOREIGN KEY `externalSource_Format`;

# ---------------------------------------------------------------------- #
# Drop table "externalFormats"                                           #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `externalFormats` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `externalFormats`;

# ---------------------------------------------------------------------- #
# Drop table "marcMap"                                                   #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `marcMap` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `marcMap`;

# ---------------------------------------------------------------------- #
# Drop table "externalData"                                              #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `externalData` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `externalData`;

# ---------------------------------------------------------------------- #
# Drop table "reindexLog"                                                #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `reindexLog` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `reindexLog`;

# ---------------------------------------------------------------------- #
# Drop table "Format"                                                    #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `Format` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `Format`;

# ---------------------------------------------------------------------- #
# Drop table "externalSource"                                            #
# ---------------------------------------------------------------------- #

# Drop constraints #

ALTER TABLE `externalSource` DROP PRIMARY KEY;

# Drop table #

DROP TABLE `externalSource`;
