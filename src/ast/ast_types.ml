open Base

type loc = Lexing.position

module type ID = sig
  type t

  val of_string : string -> t
  val to_string : t -> string
  val ( = ) : t -> t -> bool
end

module String_id = struct
  type t = string

  let of_string x = x
  let to_string x = x
  let ( = ) = String.( = )
end

module Var_name : ID = String_id
module Class_name : ID = String_id
module Trait_name : ID = String_id
module Field_name : ID = String_id

type capability = Linear | Thread | Read
type cap_trait = TCapTrait of capability * Trait_name.t
type mode = MConst | MVar
type type_field = TFieldInt

type type_expr =
  | TEInt
  | TEClass    of Class_name.t
  | TECapTrait of cap_trait
  | TEFun      of type_expr * type_expr

type field_defn = TField of mode * Field_name.t * type_field
type require_field_defn = TRequire of field_defn
type class_defn = TClass of Class_name.t * cap_trait * field_defn list
type trait_defn = TTrait of Trait_name.t * capability * require_field_defn list
