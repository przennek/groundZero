extends Node2D

enum CELL_TYPES { ACTOR, IG, DIAMOND, OBJECT, GOLD, METEORITE, BEDROCK, URANIUM }
export(CELL_TYPES) var type = ACTOR
