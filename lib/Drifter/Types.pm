package Drifter::Types;

use Type::Library -base;
use Type::Utils -all;

BEGIN { extends "Types::Standard" };

declare "ArrayOfDrifterVersions", as ArrayRef[InstanceOf["Drifter::Box::Version"]];  

declare "ArrayOfDrifterProviders", as ArrayRef[InstanceOf["Drifter::Box::Version::Providers"]];  
