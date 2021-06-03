-- TODO maybe JSON should be called "generic"
let Prelude = https://prelude.dhall-lang.org/v20.2.0/package.dhall
let Map = Prelude.Map
let JSON = Prelude.JSON
let Build = < Script : Text | Auto : Bool >
let Publish = < Registry : Text | Allow : Bool >
let Package  =
	{ Type =
		{ name : Text
		, version : Text
		, authors : Optional (List Text)
		, edition : Optional Text
		, description : Optional Text
		, documentation : Optional Text
		, readme : Optional Text
		, homepage : Optional Text
		, repository : Optional Text
		, license : Optional Text
		, license-file : Optional Text
		, keywords : Optional (List Text)
		, categories : Optional (List Text)
		, workspace : Optional Text
		, build : Optional Build
		, links : Optional Text
		, exclude : Optional (List Text)
		, include : Optional (List Text)
		, publish : Optional Publish
		, metadata : Optional JSON.Type
		, default-run : Optional Text
		, resolver : Optional Text
		}
	, default =
		{ authors = None (List Text)
		, edition = None Text
		, description = None Text
		, documentation = None Text
		, readme = None Text
		, homepage = None Text
		, repository = None Text
		, license = None Text
		, license-file = None Text
		, keywords = None (List Text)
		, categories = None (List Text)
		, workspace = None Text
		, build = None Build
		, links = None Text
		, include = None (List Text)
		, exclude = None (List Text)
		, publish = None Publish
		, metadata = None JSON.Type
		, default-run = None Text
		, resolver = None Text
		}
	}

-- TODO: maybe a better scheme for Detailed since the keys are mutex
let Dependency =
	< Version : Text
	| Detailed :
		{ version          : Optional Text
		, registry         : Optional Text
		, git              : Optional Text
		, branch           : Optional Text
		, rev              : Optional Text
		, tag              : Optional Text
		, path             : Optional Text
		, optional         : Bool
		, default-features : Optional Bool
		, features         : Optional (List Text)
		, package          : Optional Text
		}
	>

let TargetBase =
	{ Type =
		{ path       : Optional Text
		, test       : Optional Bool
		, bench      : Optional Bool
		, doc        : Optional Bool
		, harness    : Optional Bool
		, edition    : Optional Text
		}
	, default =
		{ path       = None Text
		, test       = None Bool
		, bench      = None Bool
		, doc        = None Bool
		, harness    = None Bool
		, edition    = None Text
		}
	}

let CrateType =
	< bin
	| lib
	| rlib
	| dylib
	| cdylib
	| staticlib
	| proc-macro
	>

let Lib =
	{ Type =
		TargetBase.Type //\\
		{ name       : Optional Text
		, doctest    : Optional Bool
		, proc-macro : Optional Bool
		, crate-type : Optional (List CrateType)
		}
	, default =
		TargetBase.default /\
		{ name       = None Text
		, doctest    = None Bool
		, proc-macro = None Bool
		, crate-type = None (List CrateType)
		}
	}

let Bin =
	{ Type =
		TargetBase.Type //\\
		{ name              : Text
		, required-feautres : Optional (List Text)
		}
	, default =
		TargetBase.default /\
		{ required-features = None (List Text)
		}
	}

let Example =
	{ Type =
		TargetBase.Type //\\
		{ name              : Text
		, crate-type        : Optional (List Text)
		, required-feautres : Optional (List Text)
		}
	, default =
		TargetBase.default /\
		{ crate-type        = None (List Text)
		, required-features = None (List Text)
		}
	}

let Test =
	{ Type =
		TargetBase.Type //\\
		{ name              : Text
		, required-feautres : Optional (List Text)
		}
	, default =
		TargetBase.default /\
		{ required-features = None (List Text)
		}
	}

let Bench =
	{ Type =
		TargetBase.Type //\\
		{ name              : Text
		, required-feautres : Optional (List Text)
		}
	, default =
		TargetBase.default /\
		{ required-features = None (List Text)
		}
	}


let Cargo =
	{ package            : Package.Type
	, dependencies       : Optional (Map.Type Text Dependency)
	, dev-dependencies   : Optional (Map.Type Text Dependency)
	, build-dependencies : Optional (Map.Type Text Dependency)
	, features           : Optional (Map.Type Text (List Text))
	, lib                : Optional Lib.Type
	, bin                : Optional (List Bin.Type)
	, example            : Optional (List Example.Type)
	, test               : Optional (List Test.Type)
	, bench              : Optional (List Bench.Type)
	}

let defaultCargo = \(p : Package.Type) ->
	{ package            = p
	, dependencies       = None (Map.Type Text Dependency)
	, dev-dependencies   = None (Map.Type Text Dependency)
	, build-dependencies = None (Map.Type Text Dependency)
	, features           = None (Map.Type Text (List Text))
	, lib                = None Lib.Type
	, bin                = None (List Bin.Type)
	, example            = None (List Example.Type)
	, test               = None (List Test.Type)
	, bench              = None (List Bench.Type)
	} : Cargo

-- in defaultCargo Package::{ name = "my-pkg", version = "0.0.1"  }
in
	{ Package
	, Dependency
	, TargetBase
	, CrateType
	, Lib
	, Bin
	, Example
	, Test
	, Bench
	, defaultCargo
	}


