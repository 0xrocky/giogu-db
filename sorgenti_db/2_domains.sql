CREATE DOMAIN Gender AS char
CHECK (VALUE IN ('M','F'));

CREATE DOMAIN Initials AS char(3)
CHECK (VALUE IN ('VDA','PIE','LOM','LIG','TAD','VEN','FVG','TOS','EMR','MAR','UMB','LAZ','CAM','MOL','BAS','ABR','PUG','CAL','SIC','SAR','XXX'));

CREATE DOMAIN TypeDeck AS varchar(20)
Default 'francesi'
CHECK (VALUE IN('francesi','bergamasche','bolognesi','bresciane','genovesi','lombarde','siciliane','nuoresi','piacentine','piemontesi','romagnole','romane','sarde',
'toscane_fiorentine','trentine','trevisane','triestine','viterbesi','spagnole','tedesche_austriache','svizzere','tarocchi','collezione'));

CREATE DOMAIN Console_model AS varchar(15)
CHECK (VALUE IN('Play Station','Play Station 2','Play Station 3','PSP','XBox','XBox 360','Wii','GameBoy','DS','Master System','Mega Drive','PC','Other'));

CREATE DOMAIN Console_mark AS varchar(15)
CHECK (VALUE IN('Sony','Microsoft','Nintendo','Sega','Other'));

