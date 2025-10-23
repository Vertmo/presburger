(* This program is free software; you can redistribute it and/or      *)
(* modify it under the terms of the GNU Lesser General Public License *)
(* as published by the Free Software Foundation; either version 2.1   *)
(* of the License, or (at your option) any later version.             *)
(*                                                                    *)
(* This program is distributed in the hope that it will be useful,    *)
(* but WITHOUT ANY WARRANTY; without even the implied warranty of     *)
(* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the      *)
(* GNU General Public License for more details.                       *)
(*                                                                    *)
(* You should have received a copy of the GNU Lesser General Public   *)
(* License along with this program; if not, write to the Free         *)
(* Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA *)
(* 02110-1301 USA                                                     *)


(************************************************************************)
(*                                                                      *)
(*                      Zdivides.v                                      *)
(*                                                                      *)
(*    Laurent.Thery @sophia.inria.fr        March 2002                  *)
(************************************************************************)
(** Extra properties over Z *)
From Stdlib Require Import Arith.
From Stdlib Require Import Compare.
From Stdlib Require Import Lia.
From Stdlib Require Import Zpower.
From Stdlib Require Import Zcomplements.
From Stdlib Require Import Reals.
Require Import sTactic.
From Stdlib Require Import ZArith.
From Stdlib Require Import ZArithRing.
From Stdlib Require Import Inverse_Image.
From Stdlib Require Import Wf_nat.

(** Useful lemmae *)

Theorem POS_inject : forall x : positive, Zpos x = Z_of_nat (nat_of_P x) :>Z.
intros x; elim x; simpl in |- *; auto.
intros p H; rewrite ZL6.
apply f_equal with (f := Zpos).
apply nat_of_P_inj.
rewrite nat_of_P_o_P_of_succ_nat_eq_succ; unfold nat_of_P in |- *;
 simpl in |- *.
rewrite ZL6; auto.
intros p H; unfold nat_of_P in |- *; simpl in |- *.
rewrite ZL6; simpl in |- *.
rewrite Znat.inj_plus; repeat rewrite <- H.
rewrite BinInt.Zpos_xO; ring.
Qed.

Theorem Zabs_Zopp : forall z : Z, Z.abs (- z) = Z.abs z.
intros z; case z; simpl in |- *; auto.
Qed.


Theorem Zabs_Zmult : forall z1 z2 : Z, Z.abs (z1 * z2) = (Z.abs z1 * Z.abs z2)%Z.
intros z1 z2; case z1; case z2; simpl in |- *; auto.
Qed.
 
Theorem Zle_Zabs : forall z : Z, (0 <= Z.abs z)%Z.
intros z; case z; simpl in |- *; auto with zarith.
Qed.
Hint Resolve Zle_Zabs: zarith.

Theorem Zeq_mult_simpl :
 forall a b c : Z, c <> 0%Z -> (a * c)%Z = (b * c)%Z -> a = b.
intros a b c H H0.
case (Zle_or_lt c 0); intros Zl1.
apply Zle_antisym; apply Zmult_le_reg_r with (p := (- c)%Z); try apply Z.lt_gt;
 auto with zarith; repeat rewrite <- Zopp_mult_distr_r; 
 rewrite H0; auto with zarith.
apply Zle_antisym; apply Zmult_le_reg_r with (p := c); try apply Z.lt_gt;
 auto with zarith; rewrite H0; auto with zarith.
Qed.

Fixpoint pos_eq_bool (a b : positive) {struct b} : bool :=
  match a, b with
  | xH, xH => true
  | xI a', xI b' => pos_eq_bool a' b'
  | xO a', xO b' => pos_eq_bool a' b'
  | _, _ => false
  end.
 
Theorem pos_eq_bool_correct :
 forall p q : positive,
 match pos_eq_bool p q with
 | true => p = q
 | false => p <> q
 end.
intros p q; generalize p; elim q; simpl in |- *; auto; clear p q.
intros p Rec q; case q; simpl in |- *;
 try (intros; red in |- *; intros; discriminate; fail).
intros q'; generalize (Rec q'); case (pos_eq_bool q' p); simpl in |- *; auto.
intros H1; rewrite H1; auto.
intros H1; Contradict H1; injection H1; auto.
intros p Rec q; case q; simpl in |- *;
 try (intros; red in |- *; intros; discriminate; fail).
intros q'; generalize (Rec q'); case (pos_eq_bool q' p); simpl in |- *; auto.
intros H1; rewrite H1; auto.
intros H1; Contradict H1; injection H1; auto.
intros q; case q; simpl in |- *;
 try (intros; red in |- *; intros; discriminate; fail); 
 auto.
Qed.
 
Theorem Z_O_1 : (0 < 1)%Z.
red in |- *; simpl in |- *; auto; intros; red in |- *; intros; discriminate.
Qed.
Hint Resolve Z_O_1: zarith.
 
Definition Z_eq_bool a b :=
  match a, b with
  | Z0, Z0 => true
  | Zpos a', Zpos b' => pos_eq_bool a' b'
  | Zneg a', Zneg b' => pos_eq_bool a' b'
  | _, _ => false
  end.
 
Theorem Z_eq_bool_correct :
 forall p q : Z,
 match Z_eq_bool p q with
 | true => p = q
 | false => p <> q
 end.
intros p q; case p; case q; simpl in |- *; auto;
 try (intros; red in |- *; intros; discriminate; fail).
intros p' q'; generalize (pos_eq_bool_correct q' p');
 case (pos_eq_bool q' p'); simpl in |- *; auto.
intros H1; rewrite H1; auto.
intros H1; Contradict H1; injection H1; auto.
intros p' q'; generalize (pos_eq_bool_correct q' p');
 case (pos_eq_bool q' p'); simpl in |- *; auto.
intros H1; rewrite H1; auto.
intros H1; Contradict H1; injection H1; auto.
Qed.

Theorem Zabs_eq_case :
 forall z1 z2 : Z, Z.abs z1 = Z.abs z2 -> z1 = z2 \/ z1 = (- z2)%Z.
intros z1 z2; case z1; case z2; simpl in |- *; auto;
 try (intros; discriminate); intros p1 p2 H1; injection H1;
 (intros H2; rewrite H2); auto.
Qed.
 
Theorem Zabs_intro : forall P (z : Z), P (- z)%Z -> P z -> P (Z.abs z).
intros P z; case z; simpl in |- *; auto.
Qed.
 
Theorem Zle_NEG_POS : forall p, (Zneg p <= Zpos p)%Z.
intros p; red in |- *; simpl in |- *; red in |- *; intros H; discriminate.
Qed.
Hint Resolve Zle_NEG_POS: zarith.
 
Theorem Zabs_tri : forall z1 z2 : Z, (Z.abs (z1 + z2) <= Z.abs z1 + Z.abs z2)%Z.
intros z1 z2; case z1; case z2; try (simpl in |- *; auto with zarith; fail).
intros p1 p2;
 apply
  Zabs_intro with (P := fun x => (x <= Z.abs (Zpos p2) + Z.abs (Zneg p1))%Z);
 try rewrite Zopp_plus_distr; auto with zarith.
lia.
Qed.
Hint Resolve Zabs_tri: zarith.

(** Maximum of two relative numbers *)
Definition Zmax a b := match (a ?= b)%Z with
                       | Datatypes.Lt => b
                       | _ => a
                       end.
 

(** Some basic properties of Zmax *)
Theorem Zmax1 : forall a b, (a <= Zmax a b)%Z.
intros a b; unfold Zmax in |- *; CaseEq (a ?= b)%Z; simpl in |- *;
 auto with zarith.
unfold Z.le in |- *; intros H; rewrite H; red in |- *; intros; discriminate.
Qed.
 
Theorem Zmax2 : forall a b, (b <= Zmax a b)%Z.
intros a b; unfold Zmax in |- *; CaseEq (a ?= b)%Z; simpl in |- *;
 auto with zarith.
intros H;
 (case (Zle_or_lt b a); auto; unfold Z.lt in |- *; rewrite H; intros;
   discriminate).
intros H;
 (case (Zle_or_lt b a); auto; unfold Z.lt in |- *; rewrite H; intros;
   discriminate).
Qed.

(** Turn an optional positive into a natural numbers *)
Definition oZ h := match h with
                   | None => 0
                   | Some p => nat_of_P p
                   end.
 
(** Auxillary lemma *)
Theorem ptonat_def1 : forall p q, 1 < Pmult_nat p (S (S q)).
intros p; elim p; simpl in |- *; auto with arith.
Qed.
Hint Resolve ptonat_def1: arith.

(**  Turn an optional positive into a relative number *)
Definition oZ1 (x : option positive) :=
  match x with
  | None => 0%Z
  | Some z => Zpos z
  end.
 
(** Definition of the quotient
   - Take two relative numbers [n], [m] 
   - Return the quotient ([ZERO] if [m=ZERO]) *)
Definition Zquotient (n m : Z) := Z.quot n m.

(** Useful lemmae for oZ1 and oZ *)
 
Theorem inj_oZ1 : forall z, oZ1 z = Z_of_nat (oZ z).
intros z; case z; simpl in |- *; try (exact POS_inject; auto); auto.
Qed.
 
Theorem Zero_le_oZ : forall z, 0 <= oZ z.
intros z; case z; simpl in |- *; auto with arith.
Qed.
Hint Resolve Zero_le_oZ: arith.

Fact Z_pos_div_eucl_pos : forall x y z1 z2,
    Z.pos_div_eucl x y = (z1, z2) ->
    (0 <= z1)%Z.
Proof.
  induction x; intros * EQ; simpl in *.
  - destruct Z.pos_div_eucl eqn:DIV. apply IHx in DIV.
    destruct z0; simpl; try lia.
    all:destruct (_ + 1 <? _)%Z, z; inversion EQ; lia.
  - destruct Z.pos_div_eucl eqn:DIV. apply IHx in DIV.
    destruct z0; simpl; try lia.
    all:destruct (_ <? _)%Z, z; inversion EQ; lia.
  - destruct (2 <=? y)%Z; inversion EQ; lia.
Qed.

Fact Z_div_abs : forall x y,
    y <> 0%Z ->
    (Z.abs x / Z.abs y <= Z.abs (x / y))%Z.
Proof.
  intros [] [] NZERO; simpl; auto.
  all:unfold Z.div, Z.div_eucl; try lia.
  - destruct Z.pos_div_eucl eqn:POS.
    apply Z_pos_div_eucl_pos in POS. destruct z0; simpl; lia.
  - destruct Z.pos_div_eucl eqn:POS.
    apply Z_pos_div_eucl_pos in POS. destruct z0; simpl; lia.
  - destruct Z.pos_div_eucl eqn:POS.
    rewrite Z.abs_eq; eauto using Z_pos_div_eucl_pos; lia.
Qed.

(** Zquotient is correct *)
Theorem ZquotientProp :
 forall m n : Z,
 n <> 0%Z ->
 exists r,
   m = (Zquotient m n * n + r)%Z
   /\ (Z.abs (Zquotient m n * n) <= Z.abs m)%Z
   /\ (Z.abs r < Z.abs n)%Z.
Proof.
  intros * NZERO. unfold Zquotient.
  exists (Z.rem m n)%Z. repeat split.
  - rewrite Z.mul_comm. apply Z.quot_rem'.
  - rewrite Z.abs_mul, Z.mul_comm, <-Z.quot_abs; auto.
    apply Z.mul_quot_le; lia.
  (*   specialize (Z_div_abs n _ NZERO) as GE. lia. *)
  (*   apply Z_div_abs with (y:=m) in NZERO. *)
  (*   Z_div_abs. *)
  (*   apply Z.mul_div_le. lia. *)
  - apply Z.rem_bound_abs; auto.
Qed.

(** The quotient of two positive numbers is positive *)
Theorem ZquotientPos :
  forall z1 z2 : Z, (0 <= z1)%Z -> (0 <= z2)%Z -> (0 <= Zquotient z1 z2)%Z.
Proof.
intros z1 z2 H H0; case (Z.eq_dec z2 0); intros Z1.
rewrite Z1; red in |- *; case z1; simpl in |- *; auto; intros; red in |- *;
 intros; discriminate.
case (ZquotientProp z1 z2); auto; intros r (H1, (H2, H3)).
case (Zle_or_lt 0 (Zquotient z1 z2)); auto; intros Z2.
Contradict H3; apply Zle_not_lt.
replace r with (z1 - Zquotient z1 z2 * z2)%Z;
 [ idtac | pattern z1 at 1 in |- *; rewrite H1; ring ].
repeat rewrite Z.abs_eq; auto.
pattern z2 at 1 in |- *; replace z2 with (0 + 1 * z2)%Z; [ idtac | ring ].
unfold Zminus in |- *; apply Z.le_trans with (z1 + 1 * z2)%Z; auto with zarith.
apply Zplus_le_compat_l.
rewrite Zopp_mult_distr_l.
apply Zmult_le_compat_r; auto with zarith.
unfold Zminus in |- *; rewrite Zopp_mult_distr_l; auto with zarith.
Qed.

(** Definition of m divides n ([(Zdivides n m)]) *)
Definition Zdivides (n m : Z) := Z.divide m n.
 
 
(** Some properties of Zdivides *) 
Theorem ZdividesZquotient :
 forall n m : Z, m <> 0%Z -> Zdivides n m -> n = (Zquotient n m * m)%Z.
Proof.
  intros.
  rewrite Z.mul_comm, <- Z.divide_quot_mul_exact; auto.
  now rewrite Z.mul_comm, Z.quot_mul.
Qed.
 
Theorem ZdividesZquotientInv :
 forall n m : Z, n = (Zquotient n m * m)%Z -> Zdivides n m.
intros n m H'; red in |- *.
exists (Zquotient n m); auto.
Qed.
 
Theorem ZdividesMult :
 forall n m p : Z, Zdivides n m -> Zdivides (p * n) (p * m).
intros n m p H'; red in H'.
elim H'; intros q E.
red in |- *.
exists q.
rewrite E.
auto with zarith.
Qed.
 
 
Theorem ZdividesDiv :
 forall n m p : Z, p <> 0%Z -> Zdivides (p * n) (p * m) -> Zdivides n m.
intros n m p H' H'0.
case H'0; intros q E.
exists q.
apply Zeq_mult_simpl with (c := p); auto.
rewrite (Zmult_comm n); rewrite E; ring.
Qed.
 
(* Zdivides is decidable *) 
Definition ZdividesP : forall n m : Z, {Zdivides n m} + {~ Zdivides n m}.
Proof.
  intros.
  apply Znumtheory.Zdivide_dec.
Defined.
Eval compute in (ZdividesP 4 2).

Theorem Zquotient1 : forall m : Z, Zquotient m 1 = m.
intros m.
case (ZquotientProp m 1); auto.
red in |- *; intros; discriminate.
intros z (H1, (H2, H3)).
pattern m at 2 in |- *; rewrite H1; replace z with 0%Z; try ring.
generalize H3; case z; simpl in |- *; auto; intros p; case p;
 unfold Z.lt in |- *; simpl in |- *; intros; discriminate.
Qed.

Theorem Zdivides1 : forall m : Z, Zdivides m 1.
intros m; exists m; auto with zarith.
Qed.
 

(* (* Unicity of the quotient *)  *)
(* Theorem ZquotientUnique : *)
(*  forall m n q r : Z, *)
(*  n <> 0%Z -> *)
(*  m = (q * n + r)%Z -> *)
(*  (Z.abs (q * n) <= Z.abs m)%Z -> (Z.abs r < Z.abs n)%Z -> q = Zquotient m n. *)
(* intros m n q r H' H'0 H'1 H'2. *)
(* case (ZquotientProp m n); auto; intros z (H0, (H1, H2)). *)
(* case (Zle_or_lt (Z.abs q) (Z.abs (Zquotient m n))); intros Zl1; auto with arith. *)
(* case (Zle_lt_or_eq _ _ Zl1); clear Zl1; intros Zl1; auto with arith. *)
(* - contradict H1; apply Zlt_not_le. *)
(*   pattern m at 1 in |- *; rewrite H'0. *)
(*   apply Z.le_lt_trans with (Z.abs (q * n) + Z.abs r)%Z; auto with zarith. *)
(*   apply Z.lt_le_trans with (Z.abs (q * n) + Z.abs n)%Z; auto with zarith. *)
(*   repeat rewrite Zabs_Zmult. *)
(*   replace (Z.abs q * Z.abs n + Z.abs n)%Z with (Z.succ (Z.abs q) * Z.abs n)%Z; *)
(*     [ auto with zarith | unfold Z.succ in |- *; ring ]. *)
(* - case (Zabs_eq_case _ _ Zl1); auto. *)
(*   intros H; *)
(*     (cut (Zquotient m n = 0%Z); *)
(*      [ intros H3; rewrite H; repeat rewrite H3; simpl in |- *; auto | idtac ]). *)
(*   cut (Z.abs (Zquotient m n) < 1)%Z. *)
(*   case (Zquotient m n); simpl in |- *; auto; intros p; case p; *)
(*     unfold Z.lt in |- *; simpl in |- *; intros; discriminate. *)
(*   apply Z.gt_lt; apply Zmult_gt_reg_r with (p := Z.abs n); apply Z.lt_gt; *)
(*     auto with zarith. *)
(* - case (Zle_lt_or_eq 0 (Z.abs n)); auto with zarith. intros H3. *)
(*   subst m. *)
(* (*   case (ZquotientProp ) *) *)
(* (*   rewrite Zabs_Zmult in *. *) *)
(* (*   replace (1 * Z.abs n)%Z with (Z.abs n); [ idtac | ring ]. *) *)
(* (*   apply Z.le_lt_trans with (1 := H1). *) *)
(* (*   apply Z.gt_lt; apply Zmult_gt_reg_r with (p := (1 + 1)%Z); apply Z.lt_gt; *) *)
(* (*     auto with zarith. *) *)
(* (*   replace (Z.abs m * (1 + 1))%Z with (Z.abs (m + m)). *) *)
(* (*   replace (Z.abs n * (1 + 1))%Z with (Z.abs n + Z.abs n)%Z; [ idtac | ring ]. *) *)
(* (*   pattern m at 1 in |- *; rewrite H'0; rewrite H0; rewrite H. *) *)
(* (*   replace (- Zquotient m n * n + r + (Zquotient m n * n + z))%Z with (r + z)%Z; *) *)
(* (*     [ idtac | ring ]. *) *)
(* (*   apply Z.le_lt_trans with (Z.abs r + Z.abs z)%Z; auto with zarith. *) *)
(* (*   rewrite <- (Z.abs_eq (1 + 1)); auto with zarith. *) *)
(* (*   rewrite <- Zabs_Zmult; apply f_equal with (f := Z.abs); auto with zarith. *) *)
(* (*   contradict H'1; apply Zlt_not_le. *) *)
(* (*   pattern m at 1 in |- *; rewrite H0. *) *)
(* (* apply Z.le_lt_trans with (Z.abs (Zquotient m n * n) + Z.abs z)%Z; *) *)
(* (*   auto with zarith. *) *)
(* (* apply Z.lt_le_trans with (Z.abs (Zquotient m n * n) + Z.abs n)%Z; *) *)
(* (*   auto with zarith. *) *)
(* (* repeat rewrite Zabs_Zmult. *) *)
(* (* replace (Z.abs (Zquotient m n) * Z.abs n + Z.abs n)%Z with *) *)
(* (*   (Z.succ (Z.abs (Zquotient m n)) * Z.abs n)%Z; *) *)
(* (*   [ auto with zarith | unfold Z.succ in |- *; ring ]. *) *)

(* Theorem ZquotientZopp : *)
(*  forall m n : Z, Zquotient (- m) n = (- Zquotient m n)%Z. *)
(* intros m n; case (Z.eq_dec n 0); intros Z1. *)
(* rewrite Z1; unfold Zquotient in |- *; case n; case m; simpl in |- *; auto. *)
(* case (ZquotientProp m n); auto; intros r1 (H'2, (H'3, H'4)); auto with zarith. *)
(* apply sym_equal; *)
(*  apply ZquotientUnique with (q := (- Zquotient m n)%Z) (r := (- r1)%Z);  *)
(*  auto. *)
(* pattern m at 1 in |- *; rewrite H'2; ring. *)
(* rewrite <- Zopp_mult_distr_l; repeat rewrite Zabs_Zopp; auto. *)
(* rewrite Zabs_Zopp; auto. *)
(* Qed. *)

(* (** Monotonictiy of the quotient *)  *)
(* Theorem ZquotientMonotone : *)
(*   forall n m q : Z, *)
(*     (Z.abs n <= Z.abs m)%Z -> (Z.abs (Zquotient n q) <= Z.abs (Zquotient m q))%Z. *)
(* Proof. *)
(*   intros * LE. *)
(*   rewrite ? Zdiv_abs; auto. apply Z_div_le; auto. *)
(*   unfold Zquotient. *)
(*   destruct n, m; simpl. *)
(* Qed. *)

(* Theorem ZDividesLe : *)
(*  forall n m : Z, n <> 0%Z -> Zdivides n m -> (Z.abs m <= Z.abs n)%Z. *)
(* intros n m H' H'0; case H'0; intros q E; rewrite E. *)
(* rewrite Zabs_Zmult. *)
(* pattern (Z.abs m) at 1 in |- *; replace (Z.abs m) with (Z.abs m * 1)%Z; *)
(*  [ idtac | ring ]. *)
(* apply Zmult_le_compat_l; auto with zarith. *)
(* generalize E H'; case q; simpl in |- *; auto; *)
(*  try (intros H1 H2; case H2; rewrite H1; ring; fail);  *)
(*  intros p; case p; unfold Z.le in |- *; simpl in |- *;  *)
(*  intros; red in |- *; discriminate. *)
(* Qed. *)

(* Theorem Zquotient_mult_comp : *)
(*  forall m n p : Z, p <> 0%Z -> Zquotient (m * p) (n * p) = Zquotient m n. *)
(* intros m n p Z1; case (Z.eq_dec n 0); intros Z2. *)
(* rewrite Z2; unfold Zquotient in |- *; case (m * p)%Z; case m; simpl in |- *; *)
(*  auto. *)
(* case (ZquotientProp m n); auto; intros r (H1, (H2, H3)). *)
(* (* apply sym_equal; apply ZquotientUnique with (r := (r * p)%Z); *) *)
(* (*  auto with zarith. *) *)
(* (* red in |- *; intros H; case (Zmult_integral _ _ H); intros H4; *) *)
(* (*  try (case Z1; auto; fail); case Z2; auto. *) *)
(* (* pattern m at 1 in |- *; rewrite H1; ring. *) *)
(* (* rewrite Zmult_assoc. *) *)
(* (* repeat rewrite (fun x => Zabs_Zmult x p); auto with zarith. *) *)
(* (* repeat rewrite Zabs_Zmult; auto with zarith. *) *)
(* (* apply Zmult_gt_0_lt_compat_r; auto with zarith. *) *)
(* (* apply Z.lt_gt; generalize Z1; case p; simpl in |- *; *) *)
(* (*  try (intros H4; case H4; auto; fail); unfold Z.lt in |- *;  *) *)
(* (*  simpl in |- *; auto; intros; red in |- *; intros;  *) *)
(* (*  discriminate. *) *)

Theorem ZDivides_add :
 forall n m p : Z, Zdivides n p -> Zdivides m p -> Zdivides (n + m) p.
intros n m p H' H'0.
case H'; intros z1 Hz1.
case H'0; intros z2 Hz2.
exists (z1 + z2)%Z; rewrite Hz1; rewrite Hz2; ring.
Qed.
 
Theorem NDivides_minus :
 forall n m p : Z, Zdivides n p -> Zdivides m p -> Zdivides (n - m) p.
intros n m p H' H'0.
case H'; intros z1 Hz1.
case H'0; intros z2 Hz2.
exists (z1 - z2)%Z; rewrite Hz1; rewrite Hz2; ring.
Qed.
 
Theorem ZDivides_mult :
 forall n m p q : Z, Zdivides n p -> Zdivides m q -> Zdivides (n * m) (p * q).
intros n m p q H' H'0.
case H'; intros z1 Hz1.
case H'0; intros z2 Hz2.
exists (z1 * z2)%Z; rewrite Hz1; rewrite Hz2; ring.
Qed.
 
Theorem ZdividesTrans :
 forall n m p : Z, Zdivides n m -> Zdivides m p -> Zdivides n p.
intros n m p H' H'0.
case H'; intros z1 Hz1.
case H'0; intros z2 Hz2.
exists (z1 * z2)%Z; rewrite Hz1; rewrite Hz2; ring.
Qed.
