Require Import Crypto.ModularArithmetic.PrimeFieldTheorems.
Require Import Crypto.ModularArithmetic.ModularBaseSystem.
Require Import Crypto.SpecificGen.GF5211_32Bounded.
Require Import Crypto.SpecificGen.GF5211_32ExtendedAddCoordinates.
Require Import Crypto.SpecificGen.GF5211_32BoundedAddCoordinates.
Require Import Crypto.Util.Tuple.
Require Import Crypto.Util.Tactics.

Lemma fieldwise_eq_extended_add_coordinates_full' twice_d P10 P11 P12 P13 P20 P21 P22 P23
  : Tuple.fieldwise
      (n:=4) GF5211_32BoundedCommon.eq
      (@GF5211_32BoundedAddCoordinates.add_coordinates
         twice_d P10 P11 P12 P13 P20 P21 P22 P23)
      (@ExtendedCoordinates.Extended.add_coordinates
         GF5211_32BoundedCommon.fe5211_32
         GF5211_32Bounded.add GF5211_32Bounded.sub GF5211_32Bounded.mul twice_d
         (P10, P11, P12, P13) (P20, P21, P22, P23)).
Proof.
  unfold GF5211_32BoundedCommon.eq.
  apply -> (fieldwise_map_iff (n:=4) eq GF5211_32BoundedCommon.proj1_fe5211_32 GF5211_32BoundedCommon.proj1_fe5211_32).
  rewrite add_coordinates_correct.
  cbv [AddCoordinates.add_coordinates].
  setoid_rewrite <- fieldwise_eq_edwards_extended_add_coordinates_carry_nocarry.
  unfold edwards_extended_carry_add_coordinates.
  match goal with |- ?R ?x ?y => rewrite <- (Tuple.map_id (n:=4) x) end.
  apply <- (fieldwise_map_iff (n:=4) eq (fun x => x) GF5211_32BoundedCommon.proj1_fe5211_32).
  apply ExtendedCoordinates.Extended.add_coordinates_respectful_hetero;
    intros;
    repeat match goal with
           | [ |- context[add _ _] ]
             => rewrite add_correct
           | [ |- context[sub _ _] ]
             => rewrite sub_correct
           | [ |- context[mul _ _] ]
             => rewrite mul_correct
           | _ => progress unfold Tuple.fieldwise, Tuple.fieldwise', fst, snd, eq in *
           | [ |- and _ _ ] => split
           | [ |- ?x = ?x ] => reflexivity
           | _ => progress rewrite_strat topdown hints edwards_extended_add_coordinates_correct
           | _ => congruence
           end.
Qed.

Definition add_coordinates' twice_d P1 P2
  := let '(P10, P11, P12, P13) := P1 in
     let '(P20, P21, P22, P23) := P2 in
     @GF5211_32BoundedAddCoordinates.add_coordinates
       twice_d P10 P11 P12 P13 P20 P21 P22 P23.

Definition add_coordinates twice_d P1 P2
  := Eval cbv beta iota delta [GF5211_32BoundedAddCoordinates.add_coordinates HList.mapt HList.mapt'] in
      let '(P10, P11, P12, P13) := P1 in
      let '(P20, P21, P22, P23) := P2 in
      @GF5211_32BoundedAddCoordinates.add_coordinates
        twice_d P10 P11 P12 P13 P20 P21 P22 P23.

Lemma add_coordinates_correct_full twice_d P1 P2
  : Tuple.fieldwise
      GF5211_32BoundedCommon.eq
      (add_coordinates twice_d P1 P2)
      (@ExtendedCoordinates.Extended.add_coordinates
         GF5211_32BoundedCommon.fe5211_32
         GF5211_32Bounded.add GF5211_32Bounded.sub GF5211_32Bounded.mul twice_d P1 P2).
Proof.
  destruct_head' prod.
  rewrite <- fieldwise_eq_extended_add_coordinates_full'; reflexivity.
Qed.
