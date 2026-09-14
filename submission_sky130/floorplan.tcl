# Innovus floorplan — Icarus 16c 3000MHz 3nm
# Die: 8mm x 8mm (64mm²) for 16 cores + L2 + DDR10 PHY
set die_w 8000
set die_h 8000
floorPlan -site CoreSite -r 1 0.7 20 20 20 20
# Place 16 shader cores in 4x4 grid
for {set i 0} {$i < 16} {incr i} {
  set x [expr 500 + ($i % 4)*1800]
  set y [expr 500 + ($i / 4)*1800]
  createInstGroup core_$i -fence [list $x $y [expr $x+1400] [expr $y+1400]]
  placeInstance core_$i/shader_core* $x $y
}
# L2 central 2mm x 2mm
createInstGroup L2 -fence {3000 3000 5000 5000}
# DDR10 PHY north edge 8 channels
for {set c 0} {$c < 8} {incr c} {
  set x [expr 200 + $c*950]
  placeInstance ddr10_phy_$c $x 7600
}
# Power grid 0.85V, 3nm
addRing -nets {VDD VSS} -type core_rings -layer {top top} -width 2 -spacing 1
addStripe -nets {VSS} -layer M7 -width 0.5 -spacing 5 -set_to_set_distance 40
routeDesign
# SDC already: constraints/icarus_3000mhz.sdc period 0.333ns
