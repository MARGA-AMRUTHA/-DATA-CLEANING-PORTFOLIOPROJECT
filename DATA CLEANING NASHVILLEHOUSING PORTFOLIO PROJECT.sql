--Cleaning Data in SQL QUERIES

select * from PortfolioProject.dbo.Nashvillehousing

--standardize Date format

select SaleDate, CONVERT(DATE, Saledate) from PortfolioProject.dbo.Nashvillehousing

alter table Nashvillehousing
add saledateconverted Date;

update Nashvillehousing
set SaleDateconverted = convert(date,saledate)

select SaleDateconverted, CONVERT(DATE, Saledate) from PortfolioProject.dbo.Nashvillehousing

--populate property address data


select * from PortfolioProject.dbo.Nashvillehousing
order by ParcelID


select a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress,b.PropertyAddress)
from PortfolioProject.dbo.Nashvillehousing a
join  PortfolioProject.dbo.Nashvillehousing b
      on a.ParcelID = b.ParcelID
	  AND a.[UniqueID ] <> b.[UniqueID ]
	  where a.PropertyAddress is null

update a
SET propertyaddress = ISNULL(a.propertyaddress,b.PropertyAddress)
from PortfolioProject.dbo.Nashvillehousing a
join  PortfolioProject.dbo.Nashvillehousing b
      on a.ParcelID = b.ParcelID
	  AND a.[UniqueID ] <> b.[UniqueID ]
	  where a.PropertyAddress is null

 --BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS(ADDRESS, CITY,STATE)
select PropertyAddress from PortfolioProject.dbo.Nashvillehousing

 SELECT
 SUBSTRING(PROPERTYADDRESS, 1, CHARINDEX(',',PROPERTYADDRESS)-1) AS ADDRESS,
 SUBSTRING(PROPERTYADDRESS , CHARINDEX(',',PROPERTYADDRESS)+1, LEN(PROPERTYADDRESS) )AS ADDRESS
 FROM PortfolioProject.dbo.Nashvillehousing

 alter table Nashvillehousing
add  PROPERTYSPLITADDRESS Nvarchar(255);

update Nashvillehousing
set PROPERTYSPLITADDRESS = SUBSTRING(PROPERTYADDRESS, 1,CHARINDEX(',',PROPERTYADDRESS)-1)


 alter table Nashvillehousing
add  PROPERTYSPLITcity Nvarchar(255);

update Nashvillehousing
set PROPERTYSPLITcity = SUBSTRING(PROPERTYADDRESS, CHARINDEX(',',PROPERTYADDRESS)+1,LEN(PROPERTYADDRESS))

select * from PortfolioProject.dbo.Nashvillehousing


select owneraddress from PortfolioProject.dbo.Nashvillehousing

select 
PARSENAME(REPLACE(OWNERADDRESS,',','.'),3),
PARSENAME(REPLACE(OWNERADDRESS,',','.'),2),
PARSENAME(REPLACE(OWNERADDRESS,',','.'),1)
from PortfolioProject.dbo.Nashvillehousing

ALTER table Nashvillehousing
add  ownerSPLITADDRESS Nvarchar(255);

update Nashvillehousing
set ownerSPLITADDRESS = PARSENAME(REPLACE(OWNERADDRESS,',','.'),3)

 alter table Nashvillehousing
add  ownerSPLITcity Nvarchar(255);

update Nashvillehousing
set ownerSPLITcity = PARSENAME(REPLACE(OWNERADDRESS,',','.'),2)

alter table Nashvillehousing
add  ownerSPLITstate Nvarchar(255);

update Nashvillehousing
set ownerSPLITstate = PARSENAME(REPLACE(OWNERADDRESS,',','.'),1)

select * from PortfolioProject.dbo.Nashvillehousing


--change Y and n to YES AND NO IN "SOLDASVACANT" FIELD

select DISTINCT(SoldAsVacant),COUNT(soldasvacant) from PortfolioProject.dbo.Nashvillehousing
Group by SoldAsVacant
order by 2


select SoldAsVacant
, case when SoldAsVacant = 'y' then 'yes'
       when SoldAsVacant = 'n' then 'no'
	   else SoldAsVacant
	   end
from PortfolioProject.dbo.Nashvillehousing

update Nashvillehousing
set SoldAsVacant = case when SoldAsVacant = 'y' then 'yes'
       when SoldAsVacant = 'n' then 'no'
	   else SoldAsVacant
	   end

select DISTINCT(SoldAsVacant),COUNT(soldasvacant) from PortfolioProject.dbo.Nashvillehousing
Group by SoldAsVacant
order by 2


--Remove duplicates

WITH ROWNUMCTE AS(
SELECT *, 
      ROW_NUMBER() OVER (
	  PARTITION BY PARCELID,
	               PROPERTYADDRESS,
				   SALEPRICE,
				   SALEDATE,
				   LEGALREFERENCE
				   ORDER BY
				     UNIQUEID
					 ) ROW_NUM
FROM PortfolioProject.dbo.Nashvillehousing
--ORDER BY PARCELID
)
SELECT *
FROM ROWNUMCTE
WHERE ROW_NUM > 1
ORDER BY PropertyAddress


WITH ROWNUMCTE AS(
SELECT *, 
      ROW_NUMBER() OVER (
	  PARTITION BY PARCELID,
	               PROPERTYADDRESS,
				   SALEPRICE,
				   SALEDATE,
				   LEGALREFERENCE
				   ORDER BY
				     UNIQUEID
					 ) ROW_NUM
FROM PortfolioProject.dbo.Nashvillehousing
--ORDER BY PARCELID
)
DELETE
FROM ROWNUMCTE
WHERE ROW_NUM > 1
ORDER BY PropertyAddress


--DELETE UNUSED COLUMNS

SELECT *
FROM PortfolioProject.DBO.Nashvillehousing

ALTER TABLE PortfolioProject.DBO.Nashvillehousing
DROP COLUMN OWNERADDRESS, TAXDISTRICT, PROPERTYADDRESS,SALEDATE