USE portfolio_project;

--standardize date format

SELECT *
FROM ['Nashville Housing Data for Data$'];

SELECT SaleDateConverted,CONVERT(Date,SaleDate)
FROM ['Nashville Housing Data for Data$'];

UPDATE ['Nashville Housing Data for Data$']
SET SaleDate=CONVERT(Date,SaleDate);

ALTER TABLE ['Nashville Housing Data for Data$']
ADD SaleDateConverted Date;


UPDATE ['Nashville Housing Data for Data$']
SET SaleDateConverted=CONVERT(Date,SaleDate);

--ALTER TABLE ['Nashville Housing Data for Data$']

--populate property address

SELECT *
FROM ['Nashville Housing Data for Data$']
--WHERE PropertyAddress is NULL;

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress ,ISNULL(a.PropertyAddress,b.PropertyAddress )
FROM ['Nashville Housing Data for Data$'] a
JOIN ['Nashville Housing Data for Data$'] b
ON a.ParcelID=B.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null;

UPDATE a
SET a.PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress )
FROM ['Nashville Housing Data for Data$'] a
JOIN ['Nashville Housing Data for Data$'] b
ON a.ParcelID=B.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null;

--Breaking out Address into individual columns(Address,City,State)

 SELECT PropertyAddress
FROM ['Nashville Housing Data for Data$'];

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
FROM ['Nashville Housing Data for Data$'];

ALTER TABLE ['Nashville Housing Data for Data$']
ADD PropertySplitAddress varchar(255);

UPDATE ['Nashville Housing Data for Data$']
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);

ALTER TABLE ['Nashville Housing Data for Data$']
ADD PropertySplitCity varchar(255);

UPDATE ['Nashville Housing Data for Data$']
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress));

SELECT OwnerAddress
FROM ['Nashville Housing Data for Data$'];

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM ['Nashville Housing Data for Data$'];

ALTER TABLE ['Nashville Housing Data for Data$']
ADD OwnerSplitAddress varchar(255);

UPDATE ['Nashville Housing Data for Data$']
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3);


ALTER TABLE ['Nashville Housing Data for Data$']
ADD OwnerSplitCity varchar(255);

UPDATE ['Nashville Housing Data for Data$']
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2);

ALTER TABLE ['Nashville Housing Data for Data$']
ADD OwnerSplitState varchar(255);

UPDATE ['Nashville Housing Data for Data$']
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1);

--change 'Y' and 'N' to 'Yes' and 'No' in "SoldAsVacant" field
SELECT DISTINCT SoldAsVacant 
FROM ['Nashville Housing Data for Data$'];

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant='N' THEN 'No'
     WHEN SoldAsVacant='Y' THEN 'YES'
	 ELSE SoldAsVacant
END
FROM ['Nashville Housing Data for Data$'];

UPDATE ['Nashville Housing Data for Data$']
SET SoldAsVacant=CASE WHEN SoldAsVacant='N' THEN 'No'
     WHEN SoldAsVacant='Y' THEN 'YES'
	 ELSE SoldAsVacant
END;

--Remove Duplicates
SELECT * 
FROM ['Nashville Housing Data for Data$'];

WITH rownumcte AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY ParcelID,
                               PropertyAddress,
							   SalePrice,
							   SaleDate,
							   LegalReference
							   ORDER BY UniqueID) rownum

FROM ['Nashville Housing Data for Data$'])
SELECT * FROM rownumcte
WHERE rownum>1
DELETE FROM rownumcte
WHERE rownum>1


--Delete unused coluumns

ALTER TABLE ['Nashville Housing Data for Data$']
DROP COLUMN PropertyAddress,
            SaleDate,
			OwnerAddress,
			TaxDistrict

SELECT * 
FROM ['Nashville Housing Data for Data$']


