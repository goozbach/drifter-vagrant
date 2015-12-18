package Drifter::Types;

use Type::Library -base;
use Type::Utils -all;

# ABSTRACT: Custom types for Drifter:: objects

BEGIN { extends "Types::Standard" };

declare "ArrayOfDrifterVersions", as ArrayRef[InstanceOf["Drifter::Box::Version"]];  

declare "ArrayOfDrifterProviders", as ArrayRef[InstanceOf["Drifter::Box::Version::Provider"]];  
