use portfolio;

--lets see how the data looks like
select * from dbo.nashville;


--how many unique row we have
select distinct(count(uniqueid)) from dbo.nashville;

--standardize date format
SELECT SaleDate, CONVERT(Date, SaleDate)as saledate FROM dbo.Nashville;

alter table dbo.nashville
alter column saledate date;

SELECT SaleDate, CONVERT(Date, SaleDate)as saledate FROM dbo.Nashville;

--lets see the property  address
select propertyaddress from dbo.nashville;


--we have null values in propertyaddress
select count(uniqueid) from dbo.nashville
where propertyaddress is null;

--29 null values is there
-- Also, upon checking the date, we found that the ParcelID & Address are directly correlated

select parcelid,propertyaddress
from dbo.nashville
order by parcelid;

--lets see all parcel id's have address or not
--so we have to use self join to see that

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM dbo.Nashville a
JOIN dbo.Nashville b
	 ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

---35 null values is there in first instance of parcel id 
--so we should replace the null values to the address for the second instance of parcel id

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
	   ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.Nashville a
JOIN dbo.Nashville b
	 ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

--now we should replace the null values with which we populated just above
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.Nashville a
JOIN dbo.Nashville b
	 ON a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL; 

--no error given by the upper query it means all the null values are successfully replace with second instance of parcel id
SELECT ParcelID FROM dbo.nashville
WHERE PropertyAddress IS NULL; 


-- Let's break address into Address, City & State
SELECT PropertyAddress FROM dbo.Nashville;


-- I have gone through the column and see that there is a ',' that is separating Address with the State
-- Let's split the column based on the delimiter, which is a ',' in this case

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address
FROM dbo.Nashville; 

-- We are also getting the ',' in the output
-- So, let's remove that as well

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
FROM dbo.Nashville; 

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address, 
	   SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
FROM dbo.Nashville; 

-- Perfect! 

ALTER TABLE dbo.Nashville
ADD PropertySplitAddress nvarchar(255);

UPDATE dbo.Nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);


ALTER TABLE dbo.Nashville
ADD PropertySplitCity nvarchar(255);

UPDATE dbo.Nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress));

SELECT * FROM dbo.Nashville; 

-- Let's also see the owner address column as well 

SELECT OwnerAddress FROM dbo.Nashville; 


-- We cleaned PropertyAddress column the hard way
-- Let's do the same to OwnerAddress but in a much better way

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3), 
	   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2), 
	   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM dbo.Nashville; 


-- Unique thing about PARSENAME is that it goes backwards
-- So, 1 in Parsename means that the last value is picked up and so on

ALTER TABLE dbo.Nashville
ADD OwnerSplitAddress nvarchar(255);

UPDATE dbo.Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);


ALTER TABLE dbo.Nashville
ADD OwnerAddressCity nvarchar(255);

UPDATE dbo.Nashville
SET OwnerAddressCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);


ALTER TABLE dbo.Nashville
ADD OwnerAddressState nvarchar(255);

UPDATE dbo.Nashville
SET OwnerAddressState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);


SELECT * FROM dbo.Nashville; 

-- Great! The columns have populated at the end of the table now


-- Let's also look at the column SoldAsVacant

SELECT DISTINCT(SoldAsVacant)
FROM dbo.Nashville; 

-- We have Yes, Y, No, N altogether in this column
-- So, we will have to change Y with Yes and N with No


SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant END
FROM dbo.Nashville; 


UPDATE dbo.Nashville
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
				   WHEN SoldAsVacant = 'N' THEN 'No'
				   ELSE SoldAsVacant END

SELECT DISTINCT(SoldAsVacant)
FROM dbo.Nashville; 

-- Perfect! 


-- Finally we will be deleting the duplicate rows from the data

WITH RowNumCTE as (
SELECT *, ROW_NUMBER() OVER (
		  PARTITION BY ParcelID, 
					   PropertyAddress, 
					   SalePrice, 
					   SaleDate, 
					   LegalReference
		  ORDER BY UniqueID
) RowNum
FROM dbo.Nashville
)
SELECT *
FROM RowNumCTE
WHERE RowNum > 1; 


-- Let's now delete the columns that are redundant

SELECT * FROM dbo.Nashville; 

ALTER TABLE dbo.Nashville
DROP COLUMN PropertyAddress, OwnerAddress