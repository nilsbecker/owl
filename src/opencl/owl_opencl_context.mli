(*
 * OWL - an OCaml numerical library for scientific computing
 * Copyright (c) 2016-2018 Liang Wang <liang.wang@cl.cam.ac.uk>
 *)

open Bigarray

open Owl_opencl_generated


(** {6 Type definition} *)

type num =
  | F of float
  | F32 of (float, float32_elt) Owl_dense_ndarray_generic.t
  | F64 of (float, float64_elt) Owl_dense_ndarray_generic.t
(** Type of supported number types in the `param` of `eval` function. *)

type t = {
  mutable device : cl_device_id array;
  mutable context : cl_context;
  mutable program : cl_program;
  mutable progsrc : string array;
  mutable command_queue : (cl_device_id, cl_command_queue) Hashtbl.t;
}
(** Type of context. Note this is different from OpenCL's context object. *)

val default : t
(** Default context, with all GPU devices included and pre-compiled core kernels. *)


(** {6 Query platform} *)

val platforms : unit -> cl_platform_id array
(** List all the platforms on this computer. *)

val devices : unit -> cl_device_id array
(** List all the devices (including CPUs, GPUs, accelerators, etc.) on*)

val cpu_devices : unit -> cl_device_id array
(** List all the CPU devices on this computer. *)

val gpu_devices : unit -> cl_device_id array
(** List all the GPU devices on this computer. *)

val accelerators : unit -> cl_device_id array
(** List all the accelerators on this computer. *)


(** {6 Manipulate context} *)

val ba_kernel : ('a, 'b) Owl_sparse_ndarray_generic.kind -> string -> cl_program -> cl_kernel
val create : cl_device_id array -> string array -> t
val kernels : t -> string array
val add_kernels : t -> string array -> unit
val make_kernel : t -> string -> cl_kernel
val get_opencl_ctx : t -> cl_context
val get_program : t -> cl_program
val get_dev : t -> int -> cl_device_id
val get_cmdq : t -> cl_device_id -> cl_command_queue


(** {6 Evaluate kernels} *)

val eval : ?param:num array -> ?ctx:t -> ?dev_id:int -> string -> unit
