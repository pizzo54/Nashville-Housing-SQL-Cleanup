
----------------------------------------------------------Nashville Housing------------------------------------------------------------------------

select * from NashvilleHousing

--- Standarize date Format 

select SaleDate , convert(date,SaleDate) as SaleDate from NashvilleHousing

alter table NashvilleHousing 
add SaleDate1 date ;
 
update NashvilleHousing set SaleDate1 = SaleDate ;


--------------------  populate property adresse  data
select * from NashvilleHousing   order by ParcelID

select ParcelID, PropertyAddress from  NashvilleHousing where PropertyAddress is null

select a.ParcelID, a.PropertyAddress ,b.PropertyAddress,a.PropertyAddress from NashvilleHousing a join NashvilleHousing b

on a.ParcelID = b.ParcelID  and a.[UniqueID ] <> b.[UniqueID ]	 where a.PropertyAddress is null

update a set 

PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a join NashvilleHousing b

on a.ParcelID = b.ParcelID  and a.[UniqueID ] <> b.[UniqueID ]	 where a.PropertyAddress is null

----------------------------------------------------------------------- breaking out Adresses (Property Adress /owner Adress)  into individual columns (Adress,city,state)
-------------------------------------------------------- Property Adress 
select PropertyAddress  from NashvilleHousing ;

select substring(PropertyAddress,1,(CHARINDEX(',',PropertyAddress)-1)) PropertyAddress1 ,

substring(PropertyAddress,(CHARINDEX(',',PropertyAddress)+1),LEN(PropertyAddress))  as PropertyCity from NashvilleHousing;

alter table NashvilleHousing add PropertyAddress1 varchar(100) , PropertyCity varchar(100)

update NashvilleHousing set PropertyAddress1 =  substring(PropertyAddress,1,(CHARINDEX(',',PropertyAddress)-1)) ;

update NashvilleHousing set PropertyCity =substring(PropertyAddress,(CHARINDEX(',',PropertyAddress)+1),LEN(PropertyAddress)) ;

-------------------------------------------------------- Owner Adress 
 
 select OwnerAddress from NashvilleHousing
select PARSENAME(REPLACE(OwnerAddress,',','.'),3) OwnerAdress1 ,

PARSENAME(REPLACE(OwnerAddress,',','.'),2) OwnerCity ,
 
PARSENAME(REPLACE(OwnerAddress,',','.'),1) OwnerState from NashvilleHousing ;


alter table NashvilleHousing add OwnerAdress1 varchar(100) , OwnerCity varchar(100),OwnerState varchar(100)

update NashvilleHousing set OwnerAdress1 =  PARSENAME(REPLACE(OwnerAddress,',','.'),3);

update NashvilleHousing set OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)  ;

update NashvilleHousing set OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)  ;

--------------------------------------------  change y and n to yes/no in "Sold as Vacant"

select SoldAsVacant,count(SoldAsVacant) FROM NashvilleHousing group by SoldAsVacant

select case when SoldAsVacant ='y' then 'yes'
  when SoldAsVacant='N' then 'No' 
  else SoldAsVacant 
  end 
  from NashvilleHousing

  update NashvilleHousing set SoldAsVacant =  case when SoldAsVacant ='y' then 'yes'
  when SoldAsVacant='N' then 'No' 
  else SoldAsVacant 
  end  ;

-------------------------------------------------------- Remove duplicates 

select count(distinct[UniqueID ])from NashvilleHousing
select count([UniqueID ])
from NashvilleHousing

with Duplicates as
(select ROW_NUMBER() over (partition by ParcelId,PropertyAddress,SalePrice,SaleDate1,legalReference order by UniqueId ) RowNumber from NashvilleHousing )

delete from Duplicates where RowNumber > 1;

-------------------------------------------------------- Delete Unused columns

alter table NashvilleHousing 
drop column SaleDate ,OwnerAddress,TaxDistrict,PropertyAddress ;