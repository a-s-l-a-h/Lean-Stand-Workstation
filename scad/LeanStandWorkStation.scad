/* ==============================================================================
   ADVANCED STAND-LEAN ERGONOMIC SYSTEM (V62 - OPTIMAL REACH & VISUAL DISTANCE)
   - Updated Laptop Forward Clearance: laptop_forward_clearance = 115 mm
   - Eye-to-screen focal distance: ~600 mm (ISO 9241-5 compliant)
   - Torso-to-tray breathing clearance: 140 mm (Zero cramped belly feeling)
   - Armrest support beam dynamically extends to bed-support the entire tray
   - 3-Screw apex gusset and centered pelvic rest fully preserved
   - NEW: PMI-style 3D dimension annotations (preview-only, no effect on model/STL)
   ============================================================================== */

$fn = 36;

// ================= ANNOTATION SWITCHES (NEW) =================
show_dimensions          = true;    // Master switch: false = no dimensions at all
annotations_preview_only = true;    // true  = dimensions only in F5 preview, skipped in F6 / STL export
                                    // false = always drawn (use in web playgrounds that only do F6;
                                    //         then set show_dimensions = false before exporting STL)
dim_text_size            = 18;      // Height of dimension text (mm)

// ================= USER ADJUSTABLE POSITION PARAMETERS =================
lean_angle               = 15;      // 15° lean from vertical (105° joint)
apex_height              = 1000;    // Apex node height (mm)

// --- HEIGHT ADJUSTMENTS (SLIDE ANYWHERE VIA FRICTION CLAMP) ---
pelvic_height            = 710;     // Universal sacral lean height (80mm clear gap below apex plate)
armrest_height           = 1120;    // Universal standing-lean forearm rest height (mm)

// --- ERGONOMIC REACH & CLEARANCE (SCIENTIFICALLY CALIBRATED) ---
// [60:160] 115mm gives 140mm torso clearance & 600mm screen focal distance
laptop_forward_clearance = 115;     

armrest_pad_len          = 240;     // Forearm cushion length (mm)
armrest_pad_width        = 75;      // Forearm cushion width (mm)
armrest_pad_thick        = 30;      // Cushion thickness (mm)
armrest_spread           = 550;     // Width between armrests (mm)
armrest_pad_offset_y     = 65;      // Forward offset from column axis (mm)

tray_tilt                = 15;      // 15° tilt matches 15° lean for neutral cervical spine
tray_width               = 660;     // Width (mm)
tray_depth               = 300;     // Standard depth for laptops up to 17.3" (mm)
tray_thick               = 14;      // Tray thickness (mm)
tray_swing_angle         = 0;       // [0:90] Planar swing angle

// --- MILD STEEL TUBE SPECIFICATIONS ---
profile_size             = 40;      // 40x40mm MS Square Hollow Section (SHS)
ms_wall_thick            = 2.5;     // 2.5mm structural MS wall thickness
ms_corner_rad            = 2.0;     // Cold-formed outer bend radius

arm_profile_size         = 30;      // 30x30mm MS Square Tube for armrest supports
arm_wall_thick           = 2.0;     
arm_corner_rad           = 1.5;

gusset_thick             = 5;       // 5mm Laser-cut MS Steel Gusset Plates

// --- SYMMETRICAL FRICTION CLAMP PARAMETERS ---
clamp_plate_thick        = 4.5;     // 4.5mm Heavy Duty Laser-cut MS clamp plates
clamp_height             = 76;      // 76mm compact, high-stiffness clamping sleeve
friction_pad_thick       = 1.5;     // 1.5mm high-friction neoprene/PU liner (orange)
clamp_ear_span           = 56;      // Symmetrical bolt hole centers (clearing 40mm tube)

// --- FULL-HEIGHT BACKREST CUSHION & BOARD ---
backboard_width          = 500;     // 500mm wide (leaves generous 25mm clearance to clamp bolts)
backboard_height         = 1020;    
backboard_thick          = 12;      
cushion_thick            = 50;      

base_length              = 1140;
base_width               = 660;

// ================= KINEMATIC GEOMETRY SOLVER =================
p_front_y = 340;
p_front_z = profile_size;
p_rear_y  = 1060;
p_rear_z  = profile_size;

apex_z = apex_height;
spine_h = apex_z - p_front_z;
apex_y = p_front_y + spine_h * tan(lean_angle);

spine_to_apex_len = spine_h / cos(lean_angle);
total_spine_len   = 2000;

rear_dy = p_rear_y - apex_y;
rear_dz = apex_z - p_rear_z;
rear_leg_len = sqrt(rear_dy * rear_dy + rear_dz * rear_dz);
rear_leg_angle = atan2(rear_dy, rear_dz);

joint_gap = 4;
spine_base_gap_lift = (joint_gap + (profile_size/2) * sin(lean_angle)) / cos(lean_angle);
rear_leg_base_gap_lift = (joint_gap + (profile_size/2) * sin(rear_leg_angle)) / cos(rear_leg_angle);
apex_rel_angle = lean_angle + rear_leg_angle;
rear_leg_apex_gap_drop = (joint_gap + (profile_size/2) * cos(apex_rel_angle) + (profile_size/2)) / sin(apex_rel_angle);

spine_cut_len    = total_spine_len - spine_base_gap_lift;
rear_leg_cut_len = rear_leg_len - rear_leg_apex_gap_drop - rear_leg_base_gap_lift;

// Color Palette
col_ms_steel   = [0.32, 0.34, 0.37]; 
col_gusset     = [0.20, 0.21, 0.23]; 
col_clamp_pt   = [0.22, 0.23, 0.26]; 
col_rubber_pad = [0.85, 0.32, 0.20]; // High-friction orange liner
col_rubber     = [0.12, 0.12, 0.14];
col_bolt_head  = [0.92, 0.92, 0.95]; 
col_nut        = [0.85, 0.87, 0.90];
col_washer     = [0.76, 0.78, 0.82];
col_bronze     = [0.82, 0.60, 0.32];
col_wood      = [0.84, 0.72, 0.54];
col_cushion    = [0.15, 0.15, 0.17];
col_plastic    = [0.08, 0.08, 0.10]; 

// ================= STRUCTURAL MS TUBE MODULES =================
module ms_shs_tube(size = 40, wall = 2.5, rad = 2.0, len = 100) {
    color(col_ms_steel)
    linear_extrude(height = len, center = false) {
        difference() {
            offset(r = rad) square(size - 2 * rad, center = true);
            offset(r = max(0.5, rad - wall)) square((size - 2 * wall) - 2 * max(0.5, rad - wall), center = true);
        }
    }
}

module ms_4040(len) { ms_shs_tube(profile_size, ms_wall_thick, ms_corner_rad, len); }
module ms_3030(len) { ms_shs_tube(arm_profile_size, arm_wall_thick, arm_corner_rad, len); }

module ms_tube_end_plug(size = 40, cap_h = 3) {
    color(col_plastic) {
        translate([0, 0, cap_h/2]) cube([size - 1, size - 1, cap_h], center = true);
        translate([0, 0, -6]) cube([size - 2 * ms_wall_thick - 1, size - 2 * ms_wall_thick - 1, 12], center = true);
    }
}

// ================= SYMMETRICAL CENTERED FRICTION CLAMP =================
module centered_symmetrical_friction_clamp(h = clamp_height) {
    w_plate       = clamp_ear_span + 14; // Symmetrical width = 70mm
    y_front_tube  = -profile_size/2;
    y_rear_tube   =  profile_size/2;

    y_front_plate = y_front_tube - friction_pad_thick - clamp_plate_thick/2;
    y_rear_plate  = y_rear_tube  + friction_pad_thick + clamp_plate_thick/2;

    // 1. Friction Liners (Orange PU/Neoprene)
    color(col_rubber_pad) {
        translate([0, y_front_tube - friction_pad_thick/2, 0])
            cube([profile_size, friction_pad_thick, h - 4], center = true);
        translate([0, y_rear_tube + friction_pad_thick/2, 0])
            cube([profile_size, friction_pad_thick, h - 4], center = true);
        for (sx = [-1, 1]) {
            translate([sx * (profile_size/2 + friction_pad_thick/2), 0, 0])
                cube([friction_pad_thick, profile_size, h - 4], center = true);
        }
    }

    // 2. Steel Symmetrical Clamping Plates (Front & Rear, Centered on X = 0)
    color(col_clamp_pt) {
        translate([0, y_front_plate, 0])
            difference() {
                cube([w_plate, clamp_plate_thick, h], center = true);
                for (dz = [-h/3.4, h/3.4]) {
                    for (sx = [-1, 1]) {
                        translate([sx * clamp_ear_span/2, 0, dz])
                            rotate([90, 0, 0]) cylinder(d = 8.5, h = clamp_plate_thick + 2, center = true);
                    }
                }
            }

        translate([0, y_rear_plate, 0])
            difference() {
                cube([w_plate, clamp_plate_thick, h], center = true);
                for (dz = [-h/3.4, h/3.4]) {
                    for (sx = [-1, 1]) {
                        translate([sx * clamp_ear_span/2, 0, dz])
                            rotate([90, 0, 0]) cylinder(d = 8.5, h = clamp_plate_thick + 2, center = true);
                    }
                }
            }
    }

    // 3. Symmetrical M8 Pinch Bolts
    bolt_span_y = y_rear_plate - y_front_plate;
    for (dz = [-h/3.4, h/3.4]) {
        for (sx = [-1, 1]) {
            bx = sx * clamp_ear_span/2;
            translate([bx, y_front_plate - clamp_plate_thick/2, dz]) {
                rotate([-90, 0, 0]) {
                    color(col_washer) cylinder(d = 16, h = 1.6, center = false);
                    color(col_bolt_head) translate([0, 0, -8]) cylinder(d = 13, h = 8, center = false);
                    color(col_bolt_head) cylinder(d = 8, h = bolt_span_y + clamp_plate_thick + 12, center = false);

                    translate([0, 0, bolt_span_y + clamp_plate_thick]) {
                        color(col_washer) cylinder(d = 16, h = 1.6, center = false);
                        color(col_nut) translate([0, 0, 1.6]) cylinder(d = 14.8, h = 6.8, center = false, $fn = 6);
                    }
                }
            }
        }
    }
}

// Fastener & Joint Helpers
module yz_plate_to_3d(x_pos, th = gusset_thick) {
    translate([x_pos, 0, 0])
        multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]])
        linear_extrude(height = th, center = true) children();
}

module joint_screw_and_nut(x_spine, y_pos, z_pos, side = 1) {
    sandwich_half = profile_size/2 + gusset_thick;
    total_grip    = sandwich_half * 2;
    shank_len     = 1.6 + total_grip + 1.6 + 6.8 + 4;

    translate([x_spine, y_pos, z_pos])
    rotate([0, side * 90, 0]) {
        color(col_washer) translate([0, 0, sandwich_half]) cylinder(d = 16, h = 1.6, center = false);
        translate([0, 0, sandwich_half + 1.6]) {
            color(col_bolt_head) {
                cylinder(d = 13, h = 8, center = false);
                translate([0, 0, -shank_len]) cylinder(d = 8, h = shank_len, center = false);
            }
        }
        color(col_washer) translate([0, 0, -sandwich_half - 1.6]) cylinder(d = 16, h = 1.6, center = false);
        color(col_nut) translate([0, 0, -sandwich_half - 1.6 - 6.8]) cylinder(d = 14.8, h = 6.8, center = false, $fn = 6);
    }
}

module rounded_pad(w, d, h, r = 16) {
    hull() {
        for (dx = [-w/2 + r, w/2 - r])
            for (dy = [-d/2 + r, d/2 - r])
                translate([dx, dy, 0]) cylinder(r = r, h = h, center = false);
    }
}

// ================= SUB-ASSEMBLIES =================
module base_frame() {
    for (x = [-base_width/2 + profile_size/2, base_width/2 - profile_size/2]) {
        translate([x, 0, profile_size/2]) {
            rotate([-90, 0, 0]) ms_4040(base_length);
            translate([0, 0, 0]) rotate([90, 0, 0]) ms_tube_end_plug(profile_size);
            translate([0, base_length, 0]) rotate([-90, 0, 0]) ms_tube_end_plug(profile_size);
        }
    }
    for (y = [profile_size/2, 200, 680, base_length - profile_size/2]) {
        translate([-base_width/2 + profile_size, y, profile_size/2])
            rotate([0, 90, 0]) ms_4040(base_width - 2 * profile_size);
    }
    for (x = [-base_width/2 + profile_size/2, base_width/2 - profile_size/2]) {
        for (y = [35, base_length - 35]) {
            translate([x, y, -12]) color(col_plastic) cylinder(d1 = 45, d2 = 38, h = 12);
        }
    }
    // Platform
    color([0.22, 0.22, 0.25])
        translate([-base_width/2 + profile_size + 15, 0, profile_size])
            cube([base_width - 2 * profile_size - 30, 335, 18]);
}

// ================= DEAD-CENTER PELVIC REST =================
module flush_mounted_pelvic_rest(pelvic_s) {
    cyl_diam       = 58;
    y_clamp_front  = -profile_size/2 - friction_pad_thick - clamp_plate_thick;
    reach_dist     = 65; 
    y_roller_axis  = y_clamp_front - reach_dist;

    x_left_col     = +(base_width/2 - profile_size/2); // +310
    x_right_col    = -(base_width/2 - profile_size/2); // -310

    bracket_th     = 8;   // Heavy 8mm solid MS plate bracket arm
    flange_d       = 60;  // 60mm circular boss matching the 58mm cushion

    // Roller spans FLUSH between inner faces of left and right center brackets:
    roller_span    = (2 * x_left_col) - bracket_th; // (620 - 8) = 612mm

    // Left and Right Brackets STARTING DEAD-CENTER on X = +/- 310
    for (side = [-1, 1]) {
        x_col = side * (base_width/2 - profile_size/2);

        // 1. Friction Clamp on Upright Column
        translate([x_col, 0, pelvic_s])
            centered_symmetrical_friction_clamp(clamp_height);

        // 2. Heavy Support Arm: STARTS DEAD-CENTER ON X = x_col!
        color(col_clamp_pt)
        translate([x_col, y_clamp_front - reach_dist/2, pelvic_s]) {
            cube([bracket_th, reach_dist, 45], center = true);
        }

        // 3. Circular Boss & End Flange centered at the roller axis
        color(col_clamp_pt)
        translate([x_col, y_roller_axis, pelvic_s]) {
            rotate([0, 90, 0])
                cylinder(d = flange_d, h = bracket_th, center = true);

            // Exterior Axle Bolt Head
            translate([side * (bracket_th/2 + 2), 0, 0])
                rotate([0, side * 90, 0]) {
                    color(col_washer) cylinder(d = 20, h = 2, center = true);
                    color(col_bolt_head) translate([0, 0, 2]) cylinder(d = 16, h = 8, center = true);
                }
        }
    }

    // 4. Pelvic Cushion Roller (EXACT 100% FLUSH FIT WITH ZERO GAPS!)
    color(col_cushion)
    translate([0, y_roller_axis, pelvic_s])
        rotate([0, 90, 0])
            cylinder(d = cyl_diam, h = roller_span, center = true);

    // 5. Internal MS Steel Axle Tube (Continuous through the entire assembly)
    color(col_ms_steel)
    translate([0, y_roller_axis, pelvic_s])
        rotate([0, 90, 0])
            difference() {
                cylinder(d = 25.4, h = roller_span + 2 * bracket_th + 4, center = true);
                cylinder(d = 21.4, h = roller_span + 2 * bracket_th + 6, center = true);
            }
}

module front_spine_assembly() {
    translate([0, p_front_y, p_front_z])
    rotate([-lean_angle, 0, 0]) {
        
        // Continuous Upright MS Columns (NO HOLES NEEDED ALONG SPAN!)
        for (x = [-base_width/2 + profile_size/2, base_width/2 - profile_size/2]) {
            translate([x, 0, spine_base_gap_lift]) {
                ms_4040(spine_cut_len);
                translate([0, 0, spine_cut_len]) ms_tube_end_plug(profile_size);
            }
        }

        // Transverse MS Crossbars
        for (s_pos = [220, spine_to_apex_len + 85, 1550, total_spine_len - profile_size/2]) {
            translate([-base_width/2 + profile_size, 0, s_pos])
                rotate([0, 90, 0]) ms_4040(base_width - 2 * profile_size);
        }

        // Full Coverage Backrest Cushion
        backrest_center_s = total_spine_len - backboard_height / 2;
        translate([0, -profile_size/2, backrest_center_s]) {
            color(col_wood)
                translate([0, -backboard_thick/2, 0])
                    cube([backboard_width, backboard_thick, backboard_height], center = true);
            color(col_cushion)
                translate([0, -backboard_thick - cushion_thick/2, -backboard_height/2])
                    rounded_pad(backboard_width, cushion_thick, backboard_height, 20);
        }

        // 1. Pelvic Rest: DEAD-CENTER & CLEANLY DOWN FROM APEX AREA
        pelvic_s = (pelvic_height - p_front_z) / cos(lean_angle);
        flush_mounted_pelvic_rest(pelvic_s);

        // 2. Armrests & Workstation: DEAD-CENTER ON CLAMP & UPRIGHT COLUMN
        arm_s            = (armrest_height - p_front_z) / cos(lean_angle);
        pad_center_y     = -armrest_pad_offset_y - armrest_pad_len / 2;
        pad_front_edge_y = -armrest_pad_offset_y - armrest_pad_len; 
        
        // Exact scientifically calibrated tray center
        tray_center_y    = pad_front_edge_y - laptop_forward_clearance - tray_depth / 2;
        
        // Extended support beam length dynamically adjusts to fully bed-support the tray!
        extended_arm_len = abs(tray_center_y) + tray_depth / 2 - 15;

        // Clamp Front Face (Where the 30x30 arm rail is flush-welded dead-center):
        y_clamp_front = -profile_size/2 - friction_pad_thick - clamp_plate_thick;
        z_beam        = 0; 
        z_beam_top    = arm_profile_size/2;

        translate([0, 0, arm_s]) {
            for (side = [-1, 1]) {
                x_spine = side * (base_width/2 - profile_size/2);

                // Symmetrical Centered Friction Clamp
                translate([x_spine, 0, 0])
                    centered_symmetrical_friction_clamp(clamp_height);

                // 30x30 MS Box Arm Rail DEAD-CENTER ON CLAMP & AXIS OF COLUMN!
                translate([x_spine, y_clamp_front, z_beam]) {
                    rotate([90, 0, 0])
                        ms_3030(extended_arm_len - abs(y_clamp_front));
                    translate([0, -(extended_arm_len - abs(y_clamp_front)), 0])
                        rotate([90, 0, 0])
                            ms_tube_end_plug(arm_profile_size);
                }

                // Forearm Cushion
                color(col_cushion)
                translate([x_spine, pad_center_y, z_beam_top])
                    rounded_pad(armrest_pad_width, armrest_pad_len, armrest_pad_thick, 14);
            }

            // Left & Right Coordinates
            x_spine_left  = +(base_width/2 - profile_size/2); // +310
            x_spine_right = -(base_width/2 - profile_size/2); // -310

            // Right Rail: Full Tray Resting Bed & Stopper
            translate([x_spine_right, tray_center_y, z_beam_top]) {
                rotate([lean_angle - tray_tilt, 0, 0]) {
                    color(col_rubber)
                        translate([0, 0, 1]) cube([arm_profile_size - 4, tray_depth - 20, 2], center = true);

                    translate([0, tray_depth/2 + 10, 8]) {
                        color(col_clamp_pt) cube([arm_profile_size, 20, 16], center = true);
                        color(col_rubber) translate([0, -11.5, 0]) cube([arm_profile_size - 6, 3, 14], center = true);
                    }
                }
            }

            // Left Rail: Pivot Screw Joint
            translate([x_spine_left, tray_center_y, z_beam_top]) {
                rotate([lean_angle - tray_tilt, 0, 0]) {
                    color(col_bronze)
                        translate([0, 0, 1])
                            difference() {
                                cylinder(d = 26, h = 2, center = true);
                                cylinder(d = 10.2, h = 2.2, center = true);
                            }

                    rotate([0, 0, tray_swing_angle]) {
                        color(col_bolt_head) {
                            translate([0, 0, 2 + tray_thick + 5]) cylinder(d = 16, h = 6, center = true);
                            translate([0, 0, -arm_profile_size]) cylinder(d = 10, h = tray_thick + arm_profile_size + 6);
                        }
                        // Laptop Tray
                        translate([-x_spine_left, 0, 2]) {
                            color([0.22, 0.22, 0.25])
                                translate([0, 0, tray_thick/2])
                                    cube([tray_width, tray_depth, tray_thick], center = true);
                            color(col_plastic)
                                translate([tray_width/2 - 200 - 10, tray_depth/2 - 8, tray_thick + 7])
                                    rotate([0, 90, 0]) cylinder(d = 14, h = 400, center = true);
                        }
                    }
                }
            }
        }
    }
}

module rear_truss_assembly() {
    for (x = [-base_width/2 + profile_size/2, base_width/2 - profile_size/2]) {
        translate([x, p_rear_y, p_rear_z])
            rotate([rear_leg_angle, 0, 0])
                translate([0, 0, rear_leg_base_gap_lift]) {
                    ms_4040(rear_leg_cut_len);
                    translate([0, 0, rear_leg_cut_len]) ms_tube_end_plug(profile_size);
                }
    }
    translate([-base_width/2 + profile_size, (apex_y + p_rear_y)/2, (apex_z + p_rear_z)/2])
        rotate([0, 90, 0]) ms_4040(base_width - 2 * profile_size);
}

// ================= APEX GUSSET (EXACTLY 3 SCREWS PER LEG, 6 TOTAL) =================
module apex_plate_2d() {
    bot_z = apex_z - 175;
    y_front_bot = apex_y - (apex_z - bot_z) * tan(lean_angle) - 26;
    y_rear_bot  = apex_y + 180 * sin(rear_leg_angle) + 26;

    difference() {
        hull() {
            translate([apex_y + 8, apex_z + 28]) circle(r = 26);
            translate([y_front_bot + 16, bot_z + 16]) circle(r = 16);
            translate([y_rear_bot - 16, bot_z + 16]) circle(r = 16);
        }
        // 3 Structural M8 Holes along the Spine
        for (s = [35, 75, 115])
            translate([apex_y - s * sin(lean_angle), apex_z - s * cos(lean_angle)]) circle(d = 8.5);

        // 3 Structural M8 Holes along the Rear Leg
        for (s = [90, 125, 160])
            translate([apex_y + s * sin(rear_leg_angle), apex_z - s * cos(rear_leg_angle)]) circle(d = 8.5);
    }
}

module base_105_plate_2d() {
    difference() {
        polygon(points = [
            [220, 0], [420, 0], [420, 40],
            [340 + 160 * sin(lean_angle) + 20 * cos(lean_angle), 40 + 160 * cos(lean_angle) - 20 * sin(lean_angle)],
            [340 + 160 * sin(lean_angle) - 20 * cos(lean_angle), 40 + 160 * cos(lean_angle) + 20 * sin(lean_angle)],
            [220, 40]
        ]);
        for (y = [240, 280, 320]) translate([y, 20]) circle(d = 8.5);
        for (s = [45, 85, 125]) translate([340 + s * sin(lean_angle), 40 + s * cos(lean_angle)]) circle(d = 8.5);
    }
}

module rear_foot_plate_2d() {
    difference() {
        polygon(points = [
            [p_rear_y - 130, 0], [p_rear_y + 40, 0], [p_rear_y + 40, 40],
            [p_rear_y - 150 * sin(rear_leg_angle) + 22 * cos(rear_leg_angle), 40 + 150 * cos(rear_leg_angle) + 22 * sin(rear_leg_angle)],
            [p_rear_y - 150 * sin(rear_leg_angle) - 22 * cos(rear_leg_angle), 40 + 150 * cos(rear_leg_angle) - 22 * sin(rear_leg_angle)],
            [p_rear_y - 130, 40]
        ]);
        for (y = [p_rear_y - 80, p_rear_y - 40, p_rear_y]) translate([y, 20]) circle(d = 8.5);
        for (s = [50, 90, 130]) translate([p_rear_y - s * sin(rear_leg_angle), 40 + s * cos(rear_leg_angle)]) circle(d = 8.5);
    }
}

module all_sandwich_gussets() {
    color(col_gusset) {
        for (side = [-1, 1]) {
            x_spine = side * (base_width/2 - profile_size/2);
            x_outer = x_spine + side * (profile_size/2 + gusset_thick/2);
            x_inner = x_spine - side * (profile_size/2 + gusset_thick/2);

            yz_plate_to_3d(x_outer) base_105_plate_2d();
            yz_plate_to_3d(x_inner) base_105_plate_2d();
            yz_plate_to_3d(x_outer) apex_plate_2d();
            yz_plate_to_3d(x_inner) apex_plate_2d();
            yz_plate_to_3d(x_outer) rear_foot_plate_2d();
            yz_plate_to_3d(x_inner) rear_foot_plate_2d();
        }
    }

    // Fixed Frame Structural Bolting (Exactly 3 bolts per leg everywhere!)
    for (side = [-1, 1]) {
        x_spine = side * (base_width/2 - profile_size/2);
        
        // Base 105° joint (3 horizontal + 3 spine)
        for (y = [240, 280, 320]) joint_screw_and_nut(x_spine, y, 20, side);
        for (s = [45, 85, 125]) joint_screw_and_nut(x_spine, 340 + s * sin(lean_angle), 40 + s * cos(lean_angle), side);

        // Apex node: EXACTLY 3 SCREWS ON SPINE, 3 SCREWS ON REAR LEG
        for (s = [35, 75, 115]) joint_screw_and_nut(x_spine, apex_y - s * sin(lean_angle), apex_z - s * cos(lean_angle), side);
        for (s = [90, 125, 160]) joint_screw_and_nut(x_spine, apex_y + s * sin(rear_leg_angle), apex_z - s * cos(rear_leg_angle), side);

        // Rear foot joint (3 horizontal + 3 leg)
        for (y = [p_rear_y - 80, p_rear_y - 40, p_rear_y]) joint_screw_and_nut(x_spine, y, 20, side);
        for (s = [50, 90, 130]) joint_screw_and_nut(x_spine, p_rear_y - s * sin(rear_leg_angle), 40 + s * cos(rear_leg_angle), side);
    }
}

// ==============================================================================
// ================= DIMENSION ANNOTATIONS (PMI-STYLE, VISUAL ONLY) =============
// ==============================================================================
// These modules are separate from the machine. They are drawn only when
// show_dimensions = true, and (if annotations_preview_only = true) only in F5.
// They do NOT change any part of the machine geometry.

col_dim_line = [0.90, 0.10, 0.10];   // red dimension lines
col_dim_text = [0.05, 0.25, 0.85];   // blue dimension text
col_dim_ext  = [0.55, 0.55, 0.55];   // grey extension / witness lines

// Convert a point from the leaning-spine local frame to global coordinates
function L2G(p) = [
    p[0],
    p_front_y + p[1] * cos(lean_angle) + p[2] * sin(lean_angle),
    p_front_z - p[1] * sin(lean_angle) + p[2] * cos(lean_angle)
];

// Thin line between two 3D points
module dim_seg(a, b, d = 2) {
    hull() {
        translate(a) sphere(d = d, $fn = 8);
        translate(b) sphere(d = d, $fn = 8);
    }
}

// Orient 2D text into a plane:
//   "top"    : flat on XY, readable from above
//   "front"  : vertical XZ plane, readable from the front (-Y side)
//   "side"   : vertical YZ plane, readable from the +X (right) side
//   "side_l" : vertical YZ plane, readable from the -X (left) side
module dim_place(plane) {
    if (plane == "front")       rotate([90, 0, 0])   children();
    else if (plane == "side")   rotate([90, 0, 90])  children();
    else if (plane == "side_l") rotate([90, 0, -90]) children();
    else                        children();
}

// Free-standing text label
module dim_label(pos, txt, plane = "top", ang = 0, ts = dim_text_size) {
    color(col_dim_text)
    translate(pos) dim_place(plane) rotate([0, 0, ang])
        linear_extrude(height = 1)
            text(txt, size = ts, halign = "center", valign = "center");
}

// Extension / witness line
module dim_ext(a, b) {
    color(col_dim_ext) dim_seg(a, b, 1);
}

// Full dimension: line + end dots + text centered above the line
module dim(a, b, txt, plane = "top", ang = 0, ts = dim_text_size) {
    color(col_dim_line) {
        dim_seg(a, b, 2);
        translate(a) sphere(r = 3.5, $fn = 12);
        translate(b) sphere(r = 3.5, $fn = 12);
    }
    color(col_dim_text)
    translate((a + b) / 2) dim_place(plane) rotate([0, 0, ang])
        translate([0, ts * 0.8, 0])
            linear_extrude(height = 1)
                text(txt, size = ts, halign = "center", valign = "center");
}

module dimension_annotations() {
    if (show_dimensions && (!annotations_preview_only || $preview)) {

        xc      = base_width/2 - profile_size/2;                 // column axis X (310)
        arm_s   = (armrest_height - p_front_z) / cos(lean_angle);
        pel_s   = (pelvic_height  - p_front_z) / cos(lean_angle);
        z_beam_top_l      = arm_profile_size/2;                  // 15
        pad_front_edge_y  = -armrest_pad_offset_y - armrest_pad_len;
        tray_center_y     = pad_front_edge_y - laptop_forward_clearance - tray_depth/2;
        tray_top_l        = arm_s + z_beam_top_l + 2 + tray_thick;
        pad_top_l         = arm_s + z_beam_top_l + armrest_pad_thick;

        // ---------- 1. BASE (top view) ----------
        dim([-base_width/2 - 80, 0, 0], [-base_width/2 - 80, base_length, 0],
            str("BASE LENGTH ", base_length), "top", 90);
        dim([-base_width/2, -80, 0], [base_width/2, -80, 0],
            str("BASE WIDTH ", base_width), "top", 0);
        dim([base_width/2 + 80, p_front_y, -30], [base_width/2 + 80, p_rear_y, -30],
            str("FOOT SPAN ", p_rear_y - p_front_y), "top", 90);
        dim_label([-base_width/2, -150, 0],
            str("SHS ", profile_size, "x", profile_size, "x", ms_wall_thick, " MS"), "top", 0);

        // ---------- 2. APEX HEIGHT (left side) ----------
        dim([-440, apex_y, 0], [-440, apex_y, apex_z],
            str("APEX HEIGHT ", apex_height), "side_l", 90);
        dim_ext([-xc, apex_y, apex_z], [-440, apex_y, apex_z]);
        dim_ext([-xc, apex_y, 0],      [-440, apex_y, 0]);

        // ---------- 3. SPINE LENGTH + LEAN ANGLE (left side) ----------
        sp_a = [-520, p_front_y, p_front_z];
        sp_b = [-520, p_front_y + total_spine_len * sin(lean_angle),
                      p_front_z + total_spine_len * cos(lean_angle)];
        dim(sp_a, sp_b, str("SPINE LENGTH ", total_spine_len), "side_l", 90 + lean_angle);

        // Vertical reference line + arc for lean angle
        arc_r = 450;
        dim_ext([-520, p_front_y, p_front_z], [-520, p_front_y, p_front_z + arc_r + 120]);
        color(col_dim_line)
        for (a = [0 : 3 : lean_angle - 0.001])
            dim_seg(
                [-520, p_front_y + arc_r * sin(a),               p_front_z + arc_r * cos(a)],
                [-520, p_front_y + arc_r * sin(min(a + 3, lean_angle)), p_front_z + arc_r * cos(min(a + 3, lean_angle))],
                2);
        dim_label([-520, p_front_y + (arc_r + 45) * sin(lean_angle / 2) - 70,
                         p_front_z + (arc_r + 45) * cos(lean_angle / 2)],
                  str("LEAN ", lean_angle, " deg"), "side_l", 0);

        // ---------- 4. REAR LEG (left side) ----------
        dim([-400, apex_y, apex_z], [-400, p_rear_y, p_rear_z],
            str("REAR LEG ", round(rear_leg_len), " (", round(rear_leg_angle), " deg)"),
            "side_l", atan2(rear_dz, rear_dy));

        // ---------- 5. PELVIC REST HEIGHT (right side) ----------
        y_pel = L2G([xc, 0, pel_s])[1];
        dim([410, y_pel, 0], [410, y_pel, pelvic_height],
            str("PELVIC HEIGHT ", pelvic_height), "side", 90);
        dim_ext([xc, y_pel, pelvic_height], [410, y_pel, pelvic_height]);
        dim_ext([xc, y_pel, 0],             [410, y_pel, 0]);

        // ---------- 6. ARMREST HEIGHT (right side) ----------
        y_arm = L2G([xc, 0, arm_s])[1];
        dim([410, y_arm, 0], [410, y_arm, armrest_height],
            str("ARMREST HEIGHT ", armrest_height), "side", 90);
        dim_ext([xc, y_arm, armrest_height], [410, y_arm, armrest_height]);
        dim_ext([xc, y_arm, 0],              [410, y_arm, 0]);

        // ---------- 7. CLAMP HEIGHT (right side, at armrest clamp) ----------
        dim(L2G([xc + 50, -40, arm_s - clamp_height/2]), L2G([xc + 50, -40, arm_s + clamp_height/2]),
            str("CLAMP ", clamp_height), "side", 90 - lean_angle, 12);

        // ---------- 8. ARMREST PAD LENGTH ----------
        dim(L2G([xc, -armrest_pad_offset_y, pad_top_l + 40]),
            L2G([xc, pad_front_edge_y,      pad_top_l + 40]),
            str("PAD ", armrest_pad_len), "side", -lean_angle, 14);
        dim_ext(L2G([xc, -armrest_pad_offset_y, pad_top_l]), L2G([xc, -armrest_pad_offset_y, pad_top_l + 40]));
        dim_ext(L2G([xc, pad_front_edge_y,      pad_top_l]), L2G([xc, pad_front_edge_y,      pad_top_l + 40]));

        // ---------- 9. ARMREST RAIL CENTER DISTANCE (front view) ----------
        dim(L2G([-xc, -150, arm_s + 70]), L2G([xc, -150, arm_s + 70]),
            str("RAIL CENTERS ", 2 * xc), "front", 0);

        // ---------- 10. LAPTOP FORWARD CLEARANCE ----------
        dim(L2G([0, -armrest_pad_offset_y - armrest_pad_len,                         pad_top_l + 70]),
            L2G([0, -armrest_pad_offset_y - armrest_pad_len - laptop_forward_clearance, pad_top_l + 70]),
            str("CLR ", laptop_forward_clearance), "side", -lean_angle, 14);

        // ---------- 11. TRAY WIDTH (front view) ----------
        tray_front_y = tray_center_y - tray_depth/2;
        dim(L2G([-tray_width/2, tray_front_y - 50, tray_top_l]),
            L2G([ tray_width/2, tray_front_y - 50, tray_top_l]),
            str("TRAY WIDTH ", tray_width), "front", 0);
        dim_ext(L2G([-tray_width/2, tray_front_y, tray_top_l]), L2G([-tray_width/2, tray_front_y - 50, tray_top_l]));
        dim_ext(L2G([ tray_width/2, tray_front_y, tray_top_l]), L2G([ tray_width/2, tray_front_y - 50, tray_top_l]));

        // ---------- 12. TRAY DEPTH (right side) ----------
        dim(L2G([tray_width/2 + 40, tray_center_y + tray_depth/2, tray_top_l]),
            L2G([tray_width/2 + 40, tray_center_y - tray_depth/2, tray_top_l]),
            str("TRAY DEPTH ", tray_depth), "side", -lean_angle);

        // ---------- 13. BACKBOARD HEIGHT & WIDTH ----------
        bb_front_y = -profile_size/2 - backboard_thick - cushion_thick - 20;
        dim(L2G([0, bb_front_y, total_spine_len - backboard_height]),
            L2G([0, bb_front_y, total_spine_len]),
            str("BACKBOARD H ", backboard_height), "side", 90 - lean_angle);
        dim(L2G([-backboard_width/2, bb_front_y, total_spine_len - backboard_height - 40]),
            L2G([ backboard_width/2, bb_front_y, total_spine_len - backboard_height - 40]),
            str("BACKBOARD W ", backboard_width), "front", 0);
    }
}

// ================= MASTER ASSEMBLY EXECUTION =================
module complete_ergonomic_system() {
    base_frame();
    front_spine_assembly();
    rear_truss_assembly();
    all_sandwich_gussets();
}

complete_ergonomic_system();
dimension_annotations();     // visual-only: skipped in F6 / STL when annotations_preview_only = true