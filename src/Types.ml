module type GENERATED_ENUM = sig
	type t
	val to_enum : t -> int
	val of_enum : int -> t option
	val min : int
	val max : int
	val show : t -> string
	val pp : Format.formatter -> t -> Ppx_deriving_runtime.unit
end

module Enum (E : GENERATED_ENUM) = struct
	type t = E.t
	exception NotIndex of int
	let of_index i =
		match E.of_enum i with
		| Some x -> x
		| None -> raise (NotIndex i)
	let to_index = E.to_enum
	let min_index = E.min
	let max_index = E.max
	let length = max_index - min_index + 1
	let iter f =
		for i = min_index to max_index do
			i |> of_index |> f
		done
	let show = E.show
	let pp = E.pp
	let to_string = show (* TODO *)
end

module AbilityGenerated = struct
	type t =
		| A1
		| A2
		| A3
		| A4
		| A5
		| U
	[@@deriving enum, show]
end

module Ability = Enum (AbilityGenerated)

module ItemGenerated = struct
	type t =
		| I1
		| I2
		| I3
		| I4
		| I5
		| I6
	[@@deriving enum, show]
end

module Item = Enum (ItemGenerated)

module CastMethodGenerated = struct
	type t =
		| Normal
		| Quick
		| Self
	[@@deriving enum, show]
end

module CastMethod = Enum (CastMethodGenerated)

module HeroGenerated = struct
	type t =
		| LoneDruid
		| Meepo
	[@@deriving enum, show]
end

module Hero= Enum (HeroGenerated)

module Command = struct
	type t =
		| Ability of Ability.t * CastMethod.t
		| Item of Item.t * CastMethod.t
	[@@deriving show]
	
	let to_string = show (* TODO *)
end
