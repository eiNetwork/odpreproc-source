# ---------------------------------------------------------------------- #
# Script generated with: DeZign for Databases v6.3.4                     #
# Target DBMS:           MySQL 5                                         #
# Project file:          reindexer.dez                                   #
# Project name:                                                          #
# Author:                                                                #
# Script type:           Database creation script                        #
# Created on:            2014-11-06 14:01                                #
# ---------------------------------------------------------------------- #


# ---------------------------------------------------------------------- #
# Tables                                                                 #
# ---------------------------------------------------------------------- #

# ---------------------------------------------------------------------- #
# Add table "externalSource"                                             #
# ---------------------------------------------------------------------- #

CREATE TABLE `externalSource` (
    `id` INTEGER(11) NOT NULL COMMENT 'System generated unique key for the table.',
    `source` VARCHAR(40) NOT NULL COMMENT 'Test description of the source, i.e. OverDrive',
    `externalIdField` VARCHAR(3) COMMENT 'If the external id is present in a MARC record, this is used with the externalIdSubField to indicate the MARC field and subfield where the id is located (i.e. 856u).',
    `externalIdSubField` VARCHAR(1) COMMENT 'If the external id is present in a MARC record, this is used with the externalIdField to indicate the MARC field and subfield where the id is located (i.e. 856u).',
    `externalIdRegEx` VARCHAR(255) COMMENT 'If the external id is part of a MARC subfield, this indicates the RegEx pattern needed to locate the external id withing the subfield.   For example, the OverDrive Id is part of the URL, which is stored in the 856u.',
    `sourceFormat` VARCHAR(40) COMMENT 'Indicates the format of the data from the external source, i.e. XML, JSON, MARC',
    `externalIdPrefix` VARCHAR(2) COMMENT 'If there is no ils id for the external record, the unique record is is constructed from the externalIdPrefix for the source, plus the unique id for that record at the source.',
    CONSTRAINT `PK_externalSource` PRIMARY KEY (`id`)
);

# ---------------------------------------------------------------------- #
# Add table "format"                                                     #
# ---------------------------------------------------------------------- #

CREATE TABLE `format` (
    `id` TINYINT NOT NULL AUTO_INCREMENT COMMENT 'System generated unique key.',
    `sourceId` INTEGER(11),
    `externalFormatId` VARCHAR(40) COMMENT 'Optional identfier for external formats if used by the external source.',
    `externalFormatName` VARCHAR(40) COMMENT 'The description of the format as is appears in the external information.',
    `externalFormatNumber` INTEGER(11),
    `displayFormat` VARCHAR(40) COMMENT 'The format as displaed in the Material Type facet in the user interface.   Formats are also stored in the translation maps format_map and format_category_map',
    CONSTRAINT `PK_Format` PRIMARY KEY (`id`)
) COMMENT = 'This table contains information about external formats.   Depending on the source, this external format information is displayed in the user interface in the Material Type facet.     This can be expended if we want to track compatible devices (i.e. Nook Readers, Kindle Readers) for different formats.';

# ---------------------------------------------------------------------- #
# Add table "reindexLog"                                                 #
# ---------------------------------------------------------------------- #

CREATE TABLE `reindexLog` (
    `id` INTEGER(11) NOT NULL AUTO_INCREMENT COMMENT 'System generated unique key.',
    `processName` VARCHAR(40) COMMENT 'The type of indexing process run - i.e. OverDrive API',
    `processOptions` VARCHAR(40) COMMENT 'the ini file use for the process that indicates what options were used.',
    `startTime` BIGINT(20) COMMENT 'Process start time as a unix time stamp.',
    `endTime` BIGINT(20) COMMENT 'Process start time as a unix time stamp.',
    `recordsProcessed` INTEGER(11) COMMENT 'The number of records read from the input source.',
    `recordsAdded` INTEGER(11) COMMENT 'The number of new records added to the index.',
    `recordsUpdated` INTEGER(11) COMMENT 'The number of records updated in the index.',
    `recordsDeleted` INTEGER(11) COMMENT 'The number of records deleted from the index.',
    `recordsErrors` INTEGER(11) COMMENT 'The number of input records that could not be indexed due to an error.',
    CONSTRAINT `PK_reindexLog` PRIMARY KEY (`id`)
) COMMENT = 'This is a log summarizing the reindexing processes that run, the options used, and the start and stop times.    It is maintained by the reindexing processes.';

# ---------------------------------------------------------------------- #
# Add table "externalData"                                               #
# ---------------------------------------------------------------------- #

CREATE TABLE `externalData` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'System generated unique key for the table.',
    `sourceId` INTEGER(11) NOT NULL COMMENT 'Foreign key to indicate the external record source.',
    `resourceId` INTEGER(11) COMMENT 'This is a foreign key from the resource table.    It is optional since an external indexing process could add a new record to this table that won''t exist in the resource table until it is incdexed by the main indexing process.',
    `record_Id` VARCHAR(40) COMMENT 'This is the primary identifier in the Solr core.   If the record is from the ILS, the record_id is the primary identifier from the ils.     If the record is from an external source, the record_id is the the primary identifier from that source, prefixed by a code to indicate the source.     If a record is originally added from an external source, and then a MARC record is added to the ILS, the record_id should be updated to the primary identifier from the ILS.',
    `externalId` VARCHAR(40) COMMENT 'If the record is from an iexernal source, or is accessed via an external source, this is the primary identifier for a record at that external source.    If there is no record in the the ILS,  this is the record_id, prefixed by the externalIdPrefex as specified for the source in the ExternalSource table.',
    `sourceMetaData` LONGTEXT COMMENT 'The MetaData in the the format from the source.    For example, if the source is an API that returns JSON information, this is the serialized JSON data directly from the source.',
    `sourcePrefix` VARCHAR(10),
	`indexedMetaData` LONGTEXT COMMENT 'This is the metadata as it will go into the fullrecord field in the Solr index.   Fields are mapped using the mapping information for the source in the marcMap table.',
    `limitedCopies` BOOL COMMENT 'True/False Indicates if there is a restriction of the number of copies that can be used at one time.   If there is no limit to the number of copies, the totalCopies and availableCopies are set to 9999.',
    `totalCopies` INTEGER(11) COMMENT 'Total copies in the library''s collection for this title.',
    `availableCopies` INTEGER(11) COMMENT 'The number of copies currently available for use for this title.',
    `numberOfHolds` INTEGER(11) COMMENT 'If a source allows users to request items, the number of outstanding requests for this title.',
    `dateAdded` BIGINT(20) COMMENT 'The date record was added to the table, in Unix timestamp format.',
    `lastMetaDataCheck` BIGINT(20) COMMENT 'Indicates the last time the source metadata was checked for this this record.   If the source metadata was checked, but no changes were made, the  lastMetaDataCheck is updated, but not lastMetaDataChange..',
    `lastMetaDataChange` BIGINT(20) COMMENT 'The last time the metadata for this record changed.    This is used to identify changed records for partial reindexing where only changed records are updated.',
    `lastAvailabilityCheck` BIGINT(20) COMMENT 'Indicates the last time the source source availability was checked for this this record.   If the source availability was checked, but not changed were made, the  lastAvailabilityCheck is updated, but not lastAvailabilityChange.',
    `lastAvailabilityChange` BIGINT(20) COMMENT 'The last time the availability in the external source for this item changed.    This is used to identify changed records for partial indexing where only the changed records are updated.',
    PRIMARY KEY (`id`)
);

CREATE INDEX `idX_externalData_1` ON `externalData` ();

# ---------------------------------------------------------------------- #
# Add table "marcMap"                                                    #
# ---------------------------------------------------------------------- #

CREATE TABLE `marcMap` (
	`id` BIGINT NOT NULL COMMENT 'System generated unique key for the table.',
    `sourceId` INTEGER(11) NOT NULL COMMENT 'The foreign key from the external sourrce table.',
    `sourceFieldName` VARCHAR(40) NOT NULL COMMENT 'The tag or fieldname in the source data, i.e. PrimaryCreator',
    `sourceType` VARCHAR(40) COMMENT 'the file file name, name of the API that is the source of the information for this field.    If there is a static value, the sourceType is static.',
    `indexedFieldName` VARCHAR(40) COMMENT 'The field name in the Solr Schema where this data will be stored.',
    `notes` LONGTEXT COMMENT 'Any special notes about the mapping',
    `updateMARC` VARCHAR(12) COMMENT 'If an ILS record is present for the same title, indicates how the external data should be used for this field when the record is added to or updated in the Solr index.     Values:    Replace  -- Replace all data for this field from the ILS record with the external data ILS -- ignore any external data for this field and use only the ILS data Add -- Add any external data to existing MARC data, removing any duplicate values.    Make sense only for fields where multiple values are allowed.',
    `defaultValue` VARCHAR(40) COMMENT 'The default value for this field.',
    `customMethod` TEXT COMMENT 'Indicates the name and parameters of a custom method produce the value for the field',
    `storedinSolr` TINYINT,
    `storedinDB` TINYINT,
    CONSTRAINT `PK_marcMap` PRIMARY KEY (`id`)
);

# ---------------------------------------------------------------------- #
# Add table "externalFormats"                                            #
# ---------------------------------------------------------------------- #

CREATE TABLE `externalFormats` (
    `id` INTEGER(11) NOT NULL COMMENT 'System generated unique key.',
    `externalDataId` INTEGER(11) NOT NULL COMMENT 'This is the foreign key to the externalData table',
    `formatId` TINYINT NOT NULL COMMENT 'Foreign Key from the format table.',
    `formatLink` VARCHAR(500) COMMENT 'URL link to the resource in this format',
    `dateAdded` INTEGER(11) COMMENT 'Date record was added to the table in Unix timestamp format.',
    `dateUpdated` INTEGER(11) COMMENT 'Date record was last updated in  unix timestamp format.',
    PRIMARY KEY (`id`, `formatId`)
) COMMENT = 'An single title of an electronic copy may be available in multiple formats.    For example, a downloadable eBook may be available in Adobe PDF or Kindle format.   Or, an online resource may have different links for PDF and HTML formats.';


# ---------------------------------------------------------------------- #
# Foreign key constraints                                                #
# ---------------------------------------------------------------------- #

ALTER TABLE `externalData` ADD CONSTRAINT `externalSource_externalData` 
    FOREIGN KEY (`sourceId`) REFERENCES `externalSource` (`id`) ON DELETE CASCADE;

ALTER TABLE `marcMap` ADD CONSTRAINT `externalSource_marcMap` 
    FOREIGN KEY (`sourceId`) REFERENCES `externalSource` (`id`) ON DELETE CASCADE;

ALTER TABLE `externalFormats` ADD CONSTRAINT `externalData_externalFormats` 
    FOREIGN KEY (`externalDataId`) REFERENCES `externalData` (`id`) ON DELETE CASCADE;

ALTER TABLE `externalFormats` ADD CONSTRAINT `Format_externalFormats` 
    FOREIGN KEY (`formatId`) REFERENCES `Format` (`id`);

ALTER TABLE `Format` ADD CONSTRAINT `externalSource_Format` 
    FOREIGN KEY (`sourceId`) REFERENCES `externalSource` (`id`);
