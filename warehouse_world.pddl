(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action robotMove
      :parameters (?r - robot ?l - location ?sl - location)
      :precondition (and (free ?r) (connected ?l ?sl) (at ?r ?l) (no-robot ?sl))
      :effect (and (at ?r ?sl) (not (at ?r ?l)) (not (no-robot ?sl)) (no-robot ?l))
   )

   (:action robotMoveWithPallette
      :parameters (?r - robot ?l - location ?sl - location ?p - pallette)
      :precondition (and (free ?r) (connected ?l ?sl) (at ?r ?l) (at ?p ?l) (no-robot ?sl) (no-pallette ?sl))
      :effect (and (at ?r ?sl) (not (at ?r ?l)) (not (no-robot ?sl)) (not (no-pallette ?sl)) (at ?p ?sl) (not (at ?p ?l)) (no-pallette ?l) (no-robot ?l))
   )

   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?p - pallette ?si - saleitem ?o - order)
      :precondition (and (at ?p ?l) (packing-location ?l) (packing-at ?s ?l) (contains ?p ?si) (ships ?s ?o) (orders ?o ?si) (started ?s))
      :effect (and (not (contains ?p ?si)) (includes ?s ?si))
   )

   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) (packing-location ?l) (packing-at ?s ?l))
      :effect (and (complete ?s) (not (packing-at ?s ?l)) (available ?l))
   )
)
