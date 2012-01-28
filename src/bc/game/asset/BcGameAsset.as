package bc.game.asset 
{
	import bc.core.device.BcAsset;

	/**
	 * @author Elias Ku
	 */
	public class BcGameAsset
	{
		/*[Embed(source="../../../../asset/game/sponsor/gatcha.png")]
		private static var img_sponsor_logo:Class;
		BcAsset.embedImage("sponsor_logo", img_sponsor_logo, true);
		
		[Embed(source="../../../../asset/game/mob/enemies.xml", mimeType="application/octet-stream")]
		private static var xml_mob_enemies:Class;
		BcAsset.embedXML("mob_enemies", xml_mob_enemies);
		
		[Embed(source="../../../../asset/game/mob/nuke.xml", mimeType="application/octet-stream")]
		private static var xml_mob_nuke:Class;
		BcAsset.embedXML("mob_nuke", xml_mob_nuke);
		
		[Embed(source="../../../../asset/game/mob/nuke/wave.png")]
		private static var img_mob_nuke_wave:Class;
		BcAsset.embedImage("mob_nuke_wave", img_mob_nuke_wave, true);
		
		[Embed(source="../../../../asset/game/mob/nuke/debris.png")]
		private static var img_mob_nuke_debris:Class;
		BcAsset.embedImage("mob_nuke_debris", img_mob_nuke_debris, true);
		
		[Embed(source="../../../../asset/game/mob/nuke/marker.png")]
		private static var img_mob_nuke_marker:Class;
		BcAsset.embedImage("mob_nuke_marker", img_mob_nuke_marker, true);
		
		[Embed(source="../../../../asset/game/mob/nuke/barrel.png")]
		private static var img_mob_nuke_barrel:Class;
		BcAsset.embedImage("mob_nuke_barrel", img_mob_nuke_barrel, true);
		
		[Embed(source="../../../../asset/game/mob/pig.xml", mimeType="application/octet-stream")]
		private static var xml_mob_pig:Class;
		BcAsset.embedXML("mob_pig", xml_mob_pig);
		
		[Embed(source="../../../../asset/game/mob/pig/head.png")]
		private static var img_mob_pig_head:Class;
		BcAsset.embedImage("mob_pig_head", img_mob_pig_head, true);
		
		[Embed(source="../../../../asset/game/mob/pig/tail.png")]
		private static var img_mob_pig_tail:Class;
		BcAsset.embedImage("mob_pig_tail", img_mob_pig_tail, true);
		
		[Embed(source="../../../../asset/game/mob/fish.xml", mimeType="application/octet-stream")]
		private static var xml_mob_fish:Class;
		BcAsset.embedXML("mob_fish", xml_mob_fish);
		
		[Embed(source="../../../../asset/game/mob/fish/body.png")]
		private static var img_mob_fish_body:Class;
		BcAsset.embedImage("mob_fish_body", img_mob_fish_body, true);
		
		[Embed(source="../../../../asset/game/mob/pinkhead.xml", mimeType="application/octet-stream")]
		private static var xml_mob_pinkhead:Class;
		BcAsset.embedXML("mob_pinkhead", xml_mob_pinkhead);
		
		[Embed(source="../../../../asset/game/mob/pinkhead/body.png")]
		private static var img_mob_pinkhead_body:Class;
		BcAsset.embedImage("mob_pinkhead_body", img_mob_pinkhead_body, true);
		
		[Embed(source="../../../../asset/game/mob/pinkhead/spear.png")]
		private static var img_mob_pinkhead_spear:Class;
		BcAsset.embedImage("mob_pinkhead_spear", img_mob_pinkhead_spear, true);
		
		[Embed(source="../../../../asset/game/mob/pinkhead/body_metal.png")]
		private static var img_mob_pinkhead_body_metal:Class;
		BcAsset.embedImage("mob_pinkhead_body_metal", img_mob_pinkhead_body_metal, true);
		
		[Embed(source="../../../../asset/game/mob/pinkhead/spear_metal.png")]
		private static var img_mob_pinkhead_spear_metal:Class;
		BcAsset.embedImage("mob_pinkhead_spear_metal", img_mob_pinkhead_spear_metal, true);
		
		[Embed(source="../../../../asset/game/mob/jelly.xml", mimeType="application/octet-stream")]
		private static var xml_mob_jelly:Class;
		BcAsset.embedXML("mob_jelly", xml_mob_jelly);
		
		[Embed(source="../../../../asset/game/mob/jelly/shrimp.png")]
		private static var img_mob_jelly_shrimp:Class;
		BcAsset.embedImage("mob_jelly_shrimp", img_mob_jelly_shrimp, true);
		
		[Embed(source="../../../../asset/game/mob/jelly/shrimp_big.png")]
		private static var img_mob_jelly_shrimp_big:Class;
		BcAsset.embedImage("mob_jelly_shrimp_big", img_mob_jelly_shrimp_big, true);
		
		[Embed(source="../../../../asset/game/mob/jelly/latex.png")]
		private static var img_mob_jelly_latex:Class;
		BcAsset.embedImage("mob_jelly_latex", img_mob_jelly_latex, true);
		
		[Embed(source="../../../../asset/game/mob/jelly/latex_tail.png")]
		private static var img_mob_jelly_latex_tail:Class;
		BcAsset.embedImage("mob_jelly_latex_tail", img_mob_jelly_latex_tail, true);
		
		[Embed(source="../../../../asset/game/mob/jelly/body.png")]
		private static var img_mob_jelly_body:Class;
		BcAsset.embedImage("mob_jelly_body", img_mob_jelly_body, true);
		
		[Embed(source="../../../../asset/game/mob/jelly/tail.png")]
		private static var img_mob_jelly_tail:Class;
		BcAsset.embedImage("mob_jelly_tail", img_mob_jelly_tail, true);
		
		[Embed(source="../../../../asset/game/mob/jelly/charge.png")]
		private static var img_mob_jelly_charge:Class;
		BcAsset.embedImage("mob_jelly_charge", img_mob_jelly_charge, true);
		
		[Embed(source="../../../../asset/game/mob/jelly/bullet.png")]
		private static var img_mob_jelly_bullet:Class;
		BcAsset.embedImage("mob_jelly_bullet", img_mob_jelly_bullet, true);
		
		[Embed(source="../../../../asset/game/mob/jelly/bullet_trail.png")]
		private static var img_mob_jelly_bullet_trail:Class;
		BcAsset.embedImage("mob_jelly_bullet_trail", img_mob_jelly_bullet_trail, true);
		
		[Embed(source="../../../../asset/game/mob/jelly/bullet2.png")]
		private static var img_mob_jelly_bullet2:Class;
		BcAsset.embedImage("mob_jelly_bullet2", img_mob_jelly_bullet2, true);
		
		[Embed(source="../../../../asset/game/mob/fly.xml", mimeType="application/octet-stream")]
		private static var xml_mob_fly:Class;
		BcAsset.embedXML("mob_fly", xml_mob_fly);
		
		[Embed(source="../../../../asset/game/mob/fly/body.png")]
		private static var img_mob_fly_body:Class;
		BcAsset.embedImage("mob_fly_body", img_mob_fly_body, true);
		
		[Embed(source="../../../../asset/game/mob/fly/wing.png")]
		private static var img_mob_fly_wing:Class;
		BcAsset.embedImage("mob_fly_wing", img_mob_fly_wing, true);
		
		[Embed(source="../../../../asset/game/mob/fly/head.png")]
		private static var img_mob_fly_head:Class;
		BcAsset.embedImage("mob_fly_head", img_mob_fly_head, true);
		
		[Embed(source="../../../../asset/game/mob/tooth.xml", mimeType="application/octet-stream")]
		private static var xml_mob_tooth:Class;
		BcAsset.embedXML("mob_tooth", xml_mob_tooth);
		
		[Embed(source="../../../../asset/game/mob/tooth/body.png")]
		private static var img_mob_tooth_body:Class;
		BcAsset.embedImage("mob_tooth_body", img_mob_tooth_body, true);
		
		[Embed(source="../../../../asset/game/mob/tooth/shot_face.png")]
		private static var img_mob_tooth_shot_face:Class;
		BcAsset.embedImage("mob_tooth_shot_face", img_mob_tooth_shot_face, true);
		
		[Embed(source="../../../../asset/game/mob/tooth/bullet.png")]
		private static var img_mob_tooth_bullet:Class;
		BcAsset.embedImage("mob_tooth_bullet", img_mob_tooth_bullet, true);
		
		[Embed(source="../../../../asset/game/mob/tooth/bullet_trail.png")]
		private static var img_mob_tooth_bullet_trail:Class;
		BcAsset.embedImage("mob_tooth_bullet_trail", img_mob_tooth_bullet_trail, true);
		
		[Embed(source="../../../../asset/game/mob/tooth/hit.png")]
		private static var img_mob_tooth_hit:Class;
		BcAsset.embedImage("mob_tooth_hit", img_mob_tooth_hit, true);
		
		[Embed(source="../../../../asset/game/mob/thorn.xml", mimeType="application/octet-stream")]
		private static var xml_mob_thorn:Class;
		BcAsset.embedXML("mob_thorn", xml_mob_thorn);
		
		[Embed(source="../../../../asset/game/mob/thorn/body.png")]
		private static var img_mob_thorn_body:Class;
		BcAsset.embedImage("mob_thorn_body", img_mob_thorn_body, true);
		
		[Embed(source="../../../../asset/game/mob/thorn/face.png")]
		private static var img_mob_thorn_face:Class;
		BcAsset.embedImage("mob_thorn_face", img_mob_thorn_face, true);
		
		[Embed(source="../../../../asset/game/mob/thorn/bullet.png")]
		private static var img_mob_thorn_bullet:Class;
		BcAsset.embedImage("mob_thorn_bullet", img_mob_thorn_bullet, true);
		
		[Embed(source="../../../../asset/game/mob/thorn/bullet_trail.png")]
		private static var img_mob_thorn_bullet_trail:Class;
		BcAsset.embedImage("mob_thorn_bullet_trail", img_mob_thorn_bullet_trail, true);
		
		[Embed(source="../../../../asset/game/mob/thorn/hit.png")]
		private static var img_mob_thorn_hit:Class;
		BcAsset.embedImage("mob_thorn_hit", img_mob_thorn_hit, true);
		
		[Embed(source="../../../../asset/game/mob/vision.xml", mimeType="application/octet-stream")]
		private static var xml_mob_vision:Class;
		BcAsset.embedXML("mob_vision", xml_mob_vision);
		
		[Embed(source="../../../../asset/game/mob/vision/body.png")]
		private static var img_mob_vision_body:Class;
		BcAsset.embedImage("mob_vision_body", img_mob_vision_body, true);
		
		[Embed(source="../../../../asset/game/mob/vision/radio.png")]
		private static var img_mob_vision_radio:Class;
		BcAsset.embedImage("mob_vision_radio", img_mob_vision_radio, true);
		
		[Embed(source="../../../../asset/game/mob/vision/receiver.png")]
		private static var img_mob_vision_receiver:Class;
		BcAsset.embedImage("mob_vision_receiver", img_mob_vision_receiver, true);
		
		[Embed(source="../../../../asset/game/mob/vision/screen1.png")]
		private static var img_mob_vision_screen1:Class;
		BcAsset.embedImage("mob_vision_screen1", img_mob_vision_screen1, true);
		
		[Embed(source="../../../../asset/game/mob/vision/screen2.png")]
		private static var img_mob_vision_screen2:Class;
		BcAsset.embedImage("mob_vision_screen2", img_mob_vision_screen2, true);
		
		[Embed(source="../../../../asset/game/mob/vision/screen3.png")]
		private static var img_mob_vision_screen3:Class;
		BcAsset.embedImage("mob_vision_screen3", img_mob_vision_screen3, true);
		
		[Embed(source="../../../../asset/game/mob/vision/noise.png")]
		private static var img_mob_vision_noise:Class;
		BcAsset.embedImage("mob_vision_noise", img_mob_vision_noise, true);
		
		[Embed(source="../../../../asset/game/mob/vision/hit.png")]
		private static var img_mob_vision_hit:Class;
		BcAsset.embedImage("mob_vision_hit", img_mob_vision_hit, true);
		
		[Embed(source="../../../../asset/game/mob/goo.xml", mimeType="application/octet-stream")]
		private static var xml_mob_goo:Class;
		BcAsset.embedXML("mob_goo", xml_mob_goo);
		
		[Embed(source="../../../../asset/game/mob/goo/body1.png")]
		private static var img_mob_goo_body1:Class;
		BcAsset.embedImage("mob_goo_body1", img_mob_goo_body1, true);
		
		[Embed(source="../../../../asset/game/mob/goo/body2.png")]
		private static var img_mob_goo_body2:Class;
		BcAsset.embedImage("mob_goo_body2", img_mob_goo_body2, true);
		
		[Embed(source="../../../../asset/game/mob/goo/body3.png")]
		private static var img_mob_goo_body3:Class;
		BcAsset.embedImage("mob_goo_body3", img_mob_goo_body3, true);
		
		[Embed(source="../../../../asset/game/mob/goo/hit.png")]
		private static var img_mob_goo_hit:Class;
		BcAsset.embedImage("mob_goo_hit", img_mob_goo_hit, true);
		
		[Embed(source="../../../../asset/game/mob/h1n1.xml", mimeType="application/octet-stream")]
		private static var xml_mob_h1n1:Class;
		BcAsset.embedXML("mob_h1n1", xml_mob_h1n1);
		
		[Embed(source="../../../../asset/game/mob/h1n1/body.png")]
		private static var img_mob_h1n1_body:Class;
		BcAsset.embedImage("mob_h1n1_body", img_mob_h1n1_body, true);
		
		[Embed(source="../../../../asset/game/mob/h1n1/cell.png")]
		private static var img_mob_h1n1_cell:Class;
		BcAsset.embedImage("mob_h1n1_cell", img_mob_h1n1_cell, true);
		
		[Embed(source="../../../../asset/game/mob/h1n1/cell_bad.png")]
		private static var img_mob_h1n1_cell_bad:Class;
		BcAsset.embedImage("mob_h1n1_cell_bad", img_mob_h1n1_cell_bad, true);
		
		[Embed(source="../../../../asset/game/mob/h1n1/drop.png")]
		private static var img_mob_h1n1_drop:Class;
		BcAsset.embedImage("mob_h1n1_drop", img_mob_h1n1_drop, true);
		
		[Embed(source="../../../../asset/game/mob/h1n1/patch.png")]
		private static var img_mob_h1n1_patch:Class;
		BcAsset.embedImage("mob_h1n1_patch", img_mob_h1n1_patch, true);
		
		[Embed(source="../../../../asset/game/mob/bank.xml", mimeType="application/octet-stream")]
		private static var xml_mob_bank:Class;
		BcAsset.embedXML("mob_bank", xml_mob_bank);
		
		[Embed(source="../../../../asset/game/mob/bank/body.png")]
		private static var img_mob_bank_body:Class;
		BcAsset.embedImage("mob_bank_body", img_mob_bank_body, true);
		
		[Embed(source="../../../../asset/game/mob/bank/cent.png")]
		private static var img_mob_bank_cent:Class;
		BcAsset.embedImage("mob_bank_cent", img_mob_bank_cent, true);
		
		[Embed(source="../../../../asset/game/mob/bank/dollar.png")]
		private static var img_mob_bank_dollar:Class;
		BcAsset.embedImage("mob_bank_dollar", img_mob_bank_dollar, true);
		
		[Embed(source="../../../../asset/game/mob/bank/chain.png")]
		private static var img_mob_bank_chain:Class;
		BcAsset.embedImage("mob_bank_chain", img_mob_bank_chain, true);
		
		[Embed(source="../../../../asset/game/mob/bank/chain_node.png")]
		private static var img_mob_bank_chain_node:Class;
		BcAsset.embedImage("mob_bank_chain_node", img_mob_bank_chain_node, true);
		
		[Embed(source="../../../../asset/game/mob/bank/note.png")]
		private static var img_mob_bank_note:Class;
		BcAsset.embedImage("mob_bank_note", img_mob_bank_note, true);
		
		[Embed(source="../../../../asset/game/data/items.xml", mimeType="application/octet-stream")]
		private static var xml_data_items:Class;
		BcAsset.embedXML("data_items", xml_data_items);
		
		[Embed(source="../../../../asset/game/item/star.png")]
		private static var img_item_star:Class;
		BcAsset.embedImage("item_star", img_item_star, true);
		
		[Embed(source="../../../../asset/game/item/star_back.png")]
		private static var img_item_star_back:Class;
		BcAsset.embedImage("item_star_back", img_item_star_back, true);
		
		[Embed(source="../../../../asset/game/item/gem1.png")]
		private static var img_item_gem1:Class;
		BcAsset.embedImage("item_gem1", img_item_gem1, true);
		
		[Embed(source="../../../../asset/game/item/gem2.png")]
		private static var img_item_gem2:Class;
		BcAsset.embedImage("item_gem2", img_item_gem2, true);
		
		[Embed(source="../../../../asset/game/item/gem3.png")]
		private static var img_item_gem3:Class;
		BcAsset.embedImage("item_gem3", img_item_gem3, true);
		
		[Embed(source="../../../../asset/game/item/gem_back.png")]
		private static var img_item_gem_back:Class;
		BcAsset.embedImage("item_gem_back", img_item_gem_back, true);
		
		[Embed(source="../../../../asset/game/item/health.png")]
		private static var img_item_health:Class;
		BcAsset.embedImage("item_health", img_item_health, true);
		
		[Embed(source="../../../../asset/game/item/health_back.png")]
		private static var img_item_health_back:Class;
		BcAsset.embedImage("item_health_back", img_item_health_back, true);
		
		[Embed(source="../../../../asset/game/item/bomb.png")]
		private static var img_item_bomb:Class;
		BcAsset.embedImage("item_bomb", img_item_bomb, true);
		
		[Embed(source="../../../../asset/game/item/bomb_back.png")]
		private static var img_item_bomb_back:Class;
		BcAsset.embedImage("item_bomb_back", img_item_bomb_back, true);
		
		[Embed(source="../../../../asset/game/prop/bitmaps.xml", mimeType="application/octet-stream")]
		private static var xml_prop_bitmaps:Class;
		BcAsset.embedXML("prop_bitmaps", xml_prop_bitmaps);
		
		[Embed(source="../../../../asset/game/prop/particles.xml", mimeType="application/octet-stream")]
		private static var xml_prop_particles:Class;
		BcAsset.embedXML("prop_particles", xml_prop_particles);
		
		[Embed(source="../../../../asset/game/level/data.xml", mimeType="application/octet-stream")]
		private static var xml_level_data:Class;
		BcAsset.embedXML("level_data", xml_level_data);
		
		[Embed(source="../../../../asset/game/level/level.xml", mimeType="application/octet-stream")]
		private static var xml_level_level:Class;
		BcAsset.embedXML("level_level", xml_level_level);
		
		[Embed(source="../../../../asset/game/level/sea_back_.jpg")]
		private static var img_level_sea_back:Class;
		BcAsset.embedImage("level_sea_back", img_level_sea_back, false);
		
		[Embed(source="../../../../asset/game/level/sea_back_night_.jpg")]
		private static var img_level_sea_back_night:Class;
		BcAsset.embedImage("level_sea_back_night", img_level_sea_back_night, false);
		
		[Embed(source="../../../../asset/game/level/stick.png")]
		private static var img_level_stick:Class;
		BcAsset.embedImage("level_stick", img_level_stick, true);
		
		[Embed(source="../../../../asset/game/level/bottom.png")]
		private static var img_level_bottom:Class;
		BcAsset.embedImage("level_bottom", img_level_bottom, true);
		
		[Embed(source="../../../../asset/game/level/bottom_night.png")]
		private static var img_level_bottom_night:Class;
		BcAsset.embedImage("level_bottom_night", img_level_bottom_night, true);
		
		[Embed(source="../../../../asset/game/level/shadow.png")]
		private static var img_level_shadow:Class;
		BcAsset.embedImage("level_shadow", img_level_shadow, true);
		
		[Embed(source="../../../../asset/game/level/hp.png")]
		private static var img_level_hp:Class;
		BcAsset.embedImage("level_hp", img_level_hp, true);
		
		[Embed(source="../../../../asset/game/level/score.png")]
		private static var img_level_score:Class;
		BcAsset.embedImage("level_score", img_level_score, true);
		
		[Embed(source="../../../../asset/game/level/score_decoration.png")]
		private static var img_level_score_decoration:Class;
		BcAsset.embedImage("level_score_decoration", img_level_score_decoration, true);
		
		[Embed(source="../../../../asset/game/level/bomb.png")]
		private static var img_level_bomb:Class;
		BcAsset.embedImage("level_bomb", img_level_bomb, true);
		
		[Embed(source="../../../../asset/game/level/xp/empty.png")]
		private static var img_level_xp_empty:Class;
		BcAsset.embedImage("level_xp_empty", img_level_xp_empty, true);
		
		[Embed(source="../../../../asset/game/level/xp/full.png")]
		private static var img_level_xp_full:Class;
		BcAsset.embedImage("level_xp_full", img_level_xp_full, true);
		
		[Embed(source="../../../../asset/game/level/boss/back.png")]
		private static var img_level_boss_back:Class;
		BcAsset.embedImage("level_boss_back", img_level_boss_back, true);
		
		[Embed(source="../../../../asset/game/level/boss/hp.png")]
		private static var img_level_boss_hp:Class;
		BcAsset.embedImage("level_boss_hp", img_level_boss_hp, true);
		
		[Embed(source="../../../../asset/game/level/scrap.png")]
		private static var img_level_scrap:Class;
		BcAsset.embedImage("level_scrap", img_level_scrap, true);
		
		[Embed(source="../../../../asset/game/level/digit/0.png")]
		private static var img_level_digit_0:Class;
		BcAsset.embedImage("level_digit_0", img_level_digit_0, true);
		
		[Embed(source="../../../../asset/game/level/digit/1.png")]
		private static var img_level_digit_1:Class;
		BcAsset.embedImage("level_digit_1", img_level_digit_1, true);
		
		[Embed(source="../../../../asset/game/level/digit/2.png")]
		private static var img_level_digit_2:Class;
		BcAsset.embedImage("level_digit_2", img_level_digit_2, true);
		
		[Embed(source="../../../../asset/game/level/digit/3.png")]
		private static var img_level_digit_3:Class;
		BcAsset.embedImage("level_digit_3", img_level_digit_3, true);
		
		[Embed(source="../../../../asset/game/level/digit/4.png")]
		private static var img_level_digit_4:Class;
		BcAsset.embedImage("level_digit_4", img_level_digit_4, true);
		
		[Embed(source="../../../../asset/game/level/digit/5.png")]
		private static var img_level_digit_5:Class;
		BcAsset.embedImage("level_digit_5", img_level_digit_5, true);
		
		[Embed(source="../../../../asset/game/level/digit/6.png")]
		private static var img_level_digit_6:Class;
		BcAsset.embedImage("level_digit_6", img_level_digit_6, true);
		
		[Embed(source="../../../../asset/game/level/digit/7.png")]
		private static var img_level_digit_7:Class;
		BcAsset.embedImage("level_digit_7", img_level_digit_7, true);
		
		[Embed(source="../../../../asset/game/level/digit/8.png")]
		private static var img_level_digit_8:Class;
		BcAsset.embedImage("level_digit_8", img_level_digit_8, true);
		
		[Embed(source="../../../../asset/game/level/digit/9.png")]
		private static var img_level_digit_9:Class;
		BcAsset.embedImage("level_digit_9", img_level_digit_9, true);
		
		[Embed(source="../../../../asset/game/level/hit_bottom/0.png")]
		private static var img_level_hit_bottom_0:Class;
		BcAsset.embedImage("level_hit_bottom_0", img_level_hit_bottom_0, true);
		
		[Embed(source="../../../../asset/game/level/hit_bottom/1.png")]
		private static var img_level_hit_bottom_1:Class;
		BcAsset.embedImage("level_hit_bottom_1", img_level_hit_bottom_1, true);
		
		[Embed(source="../../../../asset/game/level/hit_bottom/2.png")]
		private static var img_level_hit_bottom_2:Class;
		BcAsset.embedImage("level_hit_bottom_2", img_level_hit_bottom_2, true);
		
		[Embed(source="../../../../asset/game/level/hit_bottom/3.png")]
		private static var img_level_hit_bottom_3:Class;
		BcAsset.embedImage("level_hit_bottom_3", img_level_hit_bottom_3, true);
		
		[Embed(source="../../../../asset/game/level/hit_bottom/4.png")]
		private static var img_level_hit_bottom_4:Class;
		BcAsset.embedImage("level_hit_bottom_4", img_level_hit_bottom_4, true);
		
		[Embed(source="../../../../asset/game/level/hit_bottom/5.png")]
		private static var img_level_hit_bottom_5:Class;
		BcAsset.embedImage("level_hit_bottom_5", img_level_hit_bottom_5, true);
		
		[Embed(source="../../../../asset/game/level/hit_bottom/6.png")]
		private static var img_level_hit_bottom_6:Class;
		BcAsset.embedImage("level_hit_bottom_6", img_level_hit_bottom_6, true);
		
		[Embed(source="../../../../asset/game/level/hit_bottom/7.png")]
		private static var img_level_hit_bottom_7:Class;
		BcAsset.embedImage("level_hit_bottom_7", img_level_hit_bottom_7, true);
		
		[Embed(source="../../../../asset/game/level/hit_bottom/8.png")]
		private static var img_level_hit_bottom_8:Class;
		BcAsset.embedImage("level_hit_bottom_8", img_level_hit_bottom_8, true);
		
		[Embed(source="../../../../asset/game/level/hit_bottom/9.png")]
		private static var img_level_hit_bottom_9:Class;
		BcAsset.embedImage("level_hit_bottom_9", img_level_hit_bottom_9, true);
		
		[Embed(source="../../../../asset/game/ui/title.png")]
		private static var img_ui_title:Class;
		BcAsset.embedImage("ui_title", img_ui_title, true);
		
		[Embed(source="../../../../asset/game/ui/btn.png")]
		private static var img_ui_btn:Class;
		BcAsset.embedImage("ui_btn", img_ui_btn, true);
		
		[Embed(source="../../../../asset/game/ui/btn_back.png")]
		private static var img_ui_btn_back:Class;
		BcAsset.embedImage("ui_btn_back", img_ui_btn_back, true);
		
		[Embed(source="../../../../asset/game/ui/q.png")]
		private static var img_ui_q:Class;
		BcAsset.embedImage("ui_q", img_ui_q, true);
		
		[Embed(source="../../../../asset/game/ui/qb.png")]
		private static var img_ui_qb:Class;
		BcAsset.embedImage("ui_qb", img_ui_qb, true);
		
		[Embed(source="../../../../asset/game/ui/s1.png")]
		private static var img_ui_s1:Class;
		BcAsset.embedImage("ui_s1", img_ui_s1, true);
		
		[Embed(source="../../../../asset/game/ui/s1b.png")]
		private static var img_ui_s1b:Class;
		BcAsset.embedImage("ui_s1b", img_ui_s1b, true);
		
		[Embed(source="../../../../asset/game/ui/s2.png")]
		private static var img_ui_s2:Class;
		BcAsset.embedImage("ui_s2", img_ui_s2, true);
		
		[Embed(source="../../../../asset/game/ui/s2b.png")]
		private static var img_ui_s2b:Class;
		BcAsset.embedImage("ui_s2b", img_ui_s2b, true);
		
		[Embed(source="../../../../asset/game/ui/m1.png")]
		private static var img_ui_m1:Class;
		BcAsset.embedImage("ui_m1", img_ui_m1, true);
		
		[Embed(source="../../../../asset/game/ui/m1b.png")]
		private static var img_ui_m1b:Class;
		BcAsset.embedImage("ui_m1b", img_ui_m1b, true);
		
		[Embed(source="../../../../asset/game/ui/m2.png")]
		private static var img_ui_m2:Class;
		BcAsset.embedImage("ui_m2", img_ui_m2, true);
		
		[Embed(source="../../../../asset/game/ui/m2b.png")]
		private static var img_ui_m2b:Class;
		BcAsset.embedImage("ui_m2b", img_ui_m2b, true);
		
		[Embed(source="../../../../asset/game/fx/wave.png")]
		private static var img_fx_wave:Class;
		BcAsset.embedImage("fx_wave", img_fx_wave, true);
		
		[Embed(source="../../../../asset/game/fx/air/8.png")]
		private static var img_fx_air_8:Class;
		BcAsset.embedImage("fx_air_8", img_fx_air_8, true);
		
		[Embed(source="../../../../asset/game/fx/air/16.png")]
		private static var img_fx_air_16:Class;
		BcAsset.embedImage("fx_air_16", img_fx_air_16, true);
		
		[Embed(source="../../../../asset/game/fx/air/32.png")]
		private static var img_fx_air_32:Class;
		BcAsset.embedImage("fx_air_32", img_fx_air_32, true);
		
		[Embed(source="../../../../asset/game/audio/data.xml", mimeType="application/octet-stream")]
		private static var xml_audio_data:Class;
		BcAsset.embedXML("audio_data", xml_audio_data);
		
		[Embed(source="../../../../asset/game/audio/item_gem.mp3")]
		private static var sfx_audio_item_gem:Class;
		BcAsset.embedSound("audio_item_gem", sfx_audio_item_gem);
		
		[Embed(source="../../../../asset/game/audio/item_money.mp3")]
		private static var sfx_audio_item_money:Class;
		BcAsset.embedSound("audio_item_money", sfx_audio_item_money);
		
		[Embed(source="../../../../asset/game/audio/item_heal.mp3")]
		private static var sfx_audio_item_heal:Class;
		BcAsset.embedSound("audio_item_heal", sfx_audio_item_heal);
		
		[Embed(source="../../../../asset/game/audio/item_bomb.mp3")]
		private static var sfx_audio_item_bomb:Class;
		BcAsset.embedSound("audio_item_bomb", sfx_audio_item_bomb);
		
		[Embed(source="../../../../asset/game/audio/ui_over.mp3")]
		private static var sfx_audio_ui_over:Class;
		BcAsset.embedSound("audio_ui_over", sfx_audio_ui_over);
		
		[Embed(source="../../../../asset/game/audio/ui_click.mp3")]
		private static var sfx_audio_ui_click:Class;
		BcAsset.embedSound("audio_ui_click", sfx_audio_ui_click);
		
		[Embed(source="../../../../asset/game/audio/boss_death.mp3")]
		private static var sfx_audio_boss_death:Class;
		BcAsset.embedSound("audio_boss_death", sfx_audio_boss_death);
		
		[Embed(source="../../../../asset/game/audio/bio_death1.mp3")]
		private static var sfx_audio_bio_death1:Class;
		BcAsset.embedSound("audio_bio_death1", sfx_audio_bio_death1);
		
		[Embed(source="../../../../asset/game/audio/bio_death2.mp3")]
		private static var sfx_audio_bio_death2:Class;
		BcAsset.embedSound("audio_bio_death2", sfx_audio_bio_death2);
		
		[Embed(source="../../../../asset/game/audio/tech_death1.mp3")]
		private static var sfx_audio_tech_death1:Class;
		BcAsset.embedSound("audio_tech_death1", sfx_audio_tech_death1);
		
		[Embed(source="../../../../asset/game/audio/tech_death2.mp3")]
		private static var sfx_audio_tech_death2:Class;
		BcAsset.embedSound("audio_tech_death2", sfx_audio_tech_death2);
		
		[Embed(source="../../../../asset/game/audio/enemy_death1.mp3")]
		private static var sfx_audio_enemy_death1:Class;
		BcAsset.embedSound("audio_enemy_death1", sfx_audio_enemy_death1);
		
		[Embed(source="../../../../asset/game/audio/enemy_death2.mp3")]
		private static var sfx_audio_enemy_death2:Class;
		BcAsset.embedSound("audio_enemy_death2", sfx_audio_enemy_death2);
		
		[Embed(source="../../../../asset/game/audio/enemy_shot1.mp3")]
		private static var sfx_audio_enemy_shot1:Class;
		BcAsset.embedSound("audio_enemy_shot1", sfx_audio_enemy_shot1);
		
		[Embed(source="../../../../asset/game/audio/enemy_shot2.mp3")]
		private static var sfx_audio_enemy_shot2:Class;
		BcAsset.embedSound("audio_enemy_shot2", sfx_audio_enemy_shot2);
		
		[Embed(source="../../../../asset/game/audio/player_missle1.mp3")]
		private static var sfx_audio_player_missle1:Class;
		BcAsset.embedSound("audio_player_missle1", sfx_audio_player_missle1);
		
		[Embed(source="../../../../asset/game/audio/player_missle2.mp3")]
		private static var sfx_audio_player_missle2:Class;
		BcAsset.embedSound("audio_player_missle2", sfx_audio_player_missle2);
		
		[Embed(source="../../../../asset/game/audio/player_plasma.mp3")]
		private static var sfx_audio_player_plasma:Class;
		BcAsset.embedSound("audio_player_plasma", sfx_audio_player_plasma);
		
		[Embed(source="../../../../asset/game/audio/player_shot1.mp3")]
		private static var sfx_audio_player_shot1:Class;
		BcAsset.embedSound("audio_player_shot1", sfx_audio_player_shot1);
		
		[Embed(source="../../../../asset/game/audio/player_shot2.mp3")]
		private static var sfx_audio_player_shot2:Class;
		BcAsset.embedSound("audio_player_shot2", sfx_audio_player_shot2);
		
		[Embed(source="../../../../asset/game/audio/player_bomb.mp3")]
		private static var sfx_audio_player_bomb:Class;
		BcAsset.embedSound("audio_player_bomb", sfx_audio_player_bomb);
		
		[Embed(source="../../../../asset/game/audio/player_hit.mp3")]
		private static var sfx_audio_player_hit:Class;
		BcAsset.embedSound("audio_player_hit", sfx_audio_player_hit);
		
		[Embed(source="../../../../asset/game/audio/player_shield.mp3")]
		private static var sfx_audio_player_shield:Class;
		BcAsset.embedSound("audio_player_shield", sfx_audio_player_shield);
		
		[Embed(source="../../../../asset/game/audio/player_upgrade.mp3")]
		private static var sfx_audio_player_upgrade:Class;
		BcAsset.embedSound("audio_player_upgrade", sfx_audio_player_upgrade);
		
		[Embed(source="../../../../asset/game/audio/player_downgrade.mp3")]
		private static var sfx_audio_player_downgrade:Class;
		BcAsset.embedSound("audio_player_downgrade", sfx_audio_player_downgrade);
		
		[Embed(source="../../../../asset/game/data/player_init.xml", mimeType="application/octet-stream")]
		private static var xml_data_player_init:Class;
		BcAsset.embedXML("data_player_init", xml_data_player_init);
		
		[Embed(source="../../../../asset/game/data/player.xml", mimeType="application/octet-stream")]
		private static var xml_data_player:Class;
		BcAsset.embedXML("data_player", xml_data_player);
		
		[Embed(source="../../../../asset/game/player/body.png")]
		private static var img_player_body:Class;
		BcAsset.embedImage("player_body", img_player_body, true);
		
		[Embed(source="../../../../asset/game/player/jaw.png")]
		private static var img_player_jaw:Class;
		BcAsset.embedImage("player_jaw", img_player_jaw, true);
		
		[Embed(source="../../../../asset/game/player/eyes.png")]
		private static var img_player_eyes:Class;
		BcAsset.embedImage("player_eyes", img_player_eyes, true);
		
		[Embed(source="../../../../asset/game/player/claw_front.png")]
		private static var img_player_claw_front:Class;
		BcAsset.embedImage("player_claw_front", img_player_claw_front, true);
		
		[Embed(source="../../../../asset/game/player/claw_back.png")]
		private static var img_player_claw_back:Class;
		BcAsset.embedImage("player_claw_back", img_player_claw_back, true);
		
		[Embed(source="../../../../asset/game/player/claw_link.png")]
		private static var img_player_claw_link:Class;
		BcAsset.embedImage("player_claw_link", img_player_claw_link, true);
		
		[Embed(source="../../../../asset/game/player/marker.png")]
		private static var img_player_marker:Class;
		BcAsset.embedImage("player_marker", img_player_marker, true);
		
		[Embed(source="../../../../asset/game/player/plasma.png")]
		private static var img_player_plasma:Class;
		BcAsset.embedImage("player_plasma", img_player_plasma, true);
		
		[Embed(source="../../../../asset/game/player/plasma_trail.png")]
		private static var img_player_plasma_trail:Class;
		BcAsset.embedImage("player_plasma_trail", img_player_plasma_trail, true);
		
		[Embed(source="../../../../asset/game/player/missle.png")]
		private static var img_player_missle:Class;
		BcAsset.embedImage("player_missle", img_player_missle, true);
		
		[Embed(source="../../../../asset/game/player/missle_trail.png")]
		private static var img_player_missle_trail:Class;
		BcAsset.embedImage("player_missle_trail", img_player_missle_trail, true);
		
		[Embed(source="../../../../asset/game/player/bullet/a1.png")]
		private static var img_player_bullet_a1:Class;
		BcAsset.embedImage("player_bullet_a1", img_player_bullet_a1, true);
		
		[Embed(source="../../../../asset/game/player/bullet/a2.png")]
		private static var img_player_bullet_a2:Class;
		BcAsset.embedImage("player_bullet_a2", img_player_bullet_a2, true);
		
		[Embed(source="../../../../asset/game/player/bullet/a3.png")]
		private static var img_player_bullet_a3:Class;
		BcAsset.embedImage("player_bullet_a3", img_player_bullet_a3, true);
		
		[Embed(source="../../../../asset/game/fx/drop.png")]
		private static var img_fx_drop:Class;
		BcAsset.embedImage("fx_drop", img_fx_drop, true);
		
		[Embed(source="../../../../asset/game/fx/star.png")]
		private static var img_fx_star:Class;
		BcAsset.embedImage("fx_star", img_fx_star, true);
		
		[Embed(source="../../../../asset/game/fx/cell.png")]
		private static var img_fx_cell:Class;
		BcAsset.embedImage("fx_cell", img_fx_cell, true);
		
		[Embed(source="../../../../asset/game/fx/burst_star/0.png")]
		private static var img_fx_burst_star_0:Class;
		BcAsset.embedImage("fx_burst_star_0", img_fx_burst_star_0, true);
		
		[Embed(source="../../../../asset/game/fx/burst_star/1.png")]
		private static var img_fx_burst_star_1:Class;
		BcAsset.embedImage("fx_burst_star_1", img_fx_burst_star_1, true);
		
		[Embed(source="../../../../asset/game/fx/burst_star/2.png")]
		private static var img_fx_burst_star_2:Class;
		BcAsset.embedImage("fx_burst_star_2", img_fx_burst_star_2, true);
		
		[Embed(source="../../../../asset/game/fx/burst_star/3.png")]
		private static var img_fx_burst_star_3:Class;
		BcAsset.embedImage("fx_burst_star_3", img_fx_burst_star_3, true);
		
		[Embed(source="../../../../asset/game/fx/burst_star/4.png")]
		private static var img_fx_burst_star_4:Class;
		BcAsset.embedImage("fx_burst_star_4", img_fx_burst_star_4, true);
		
		[Embed(source="../../../../asset/game/fx/burst_star/5.png")]
		private static var img_fx_burst_star_5:Class;
		BcAsset.embedImage("fx_burst_star_5", img_fx_burst_star_5, true);
		
		[Embed(source="../../../../asset/game/music.xml", mimeType="application/octet-stream")]
		private static var xml_music:Class;
		BcAsset.embedXML("music", xml_music);
		
		[Embed(source="../../../../asset/game/music/gameover.mp3")]
		private static var sfx_music_gameover:Class;
		BcAsset.embedSound("music_gameover", sfx_music_gameover);
		
		[Embed(source="../../../../asset/game/music/menu.mp3")]
		private static var sfx_music_menu:Class;
		BcAsset.embedSound("music_menu", sfx_music_menu);
		
		[Embed(source="../../../../asset/game/music/stage.mp3")]
		private static var sfx_music_stage:Class;
		BcAsset.embedSound("music_stage", sfx_music_stage);
		
		[Embed(source="../../../../asset/game/music/boss.mp3")]
		private static var sfx_music_boss:Class;
		BcAsset.embedSound("music_boss", sfx_music_boss);
		
		[Embed(source="../../../../asset/game/music/victory.mp3")]
		private static var sfx_music_victory:Class;
		BcAsset.embedSound("music_victory", sfx_music_victory);
		
		[Embed(source="../../../../asset/game/ui/ddg.png")]
		private static var img_ui_ddg:Class;
		BcAsset.embedImage("ui_ddg", img_ui_ddg, true);
		
		[Embed(source="../../../../asset/game/audio/tv_death.mp3")]
		private static var sfx_audio_tv_death:Class;
		BcAsset.embedSound("audio_tv_death", sfx_audio_tv_death);
		
		[Embed(source="../../../../asset/game/audio/tv_shot.mp3")]
		private static var sfx_audio_tv_shot:Class;
		BcAsset.embedSound("audio_tv_shot", sfx_audio_tv_shot);*/
		
		public function BcGameAsset(callback:Function)
		{
			BcAsset.loadPath("../asset/game.xml", callback);
			//callback();
		}
	}
}
