# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end




# Clear existing data (only in development!)
if Rails.env.development?
  puts "Clearing existing data..."
  OrderItem.destroy_all
  Order.destroy_all
  CartItem.destroy_all
  Cart.destroy_all
  Address.destroy_all
  ProductCategory.destroy_all
  Product.destroy_all
  Category.destroy_all
  Province.destroy_all
  User.destroy_all
else
  puts "Skipping data clearing in #{Rails.env} environment for safety"
end

puts "Creating provinces with tax rates..."

# Canadian Provinces and Territories with accurate tax rates (as of 2024)
provinces_data = [
  { name: "Alberta", code: "AB", gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0 },
  { name: "British Columbia", code: "BC", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.0 },
  { name: "Manitoba", code: "MB", gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0.0 },
  { name: "New Brunswick", code: "NB", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15 },
  { name: "Newfoundland and Labrador", code: "NL", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15 },
  { name: "Northwest Territories", code: "NT", gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0 },
  { name: "Nova Scotia", code: "NS", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15 },
  { name: "Nunavut", code: "NU", gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0 },
  { name: "Ontario", code: "ON", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.13 },
  { name: "Prince Edward Island", code: "PE", gst_rate: 0.0, pst_rate: 0.0, hst_rate: 0.15 },
  { name: "Quebec", code: "QC", gst_rate: 0.05, pst_rate: 0.09975, hst_rate: 0.0 },
  { name: "Saskatchewan", code: "SK", gst_rate: 0.05, pst_rate: 0.06, hst_rate: 0.0 },
  { name: "Yukon", code: "YT", gst_rate: 0.05, pst_rate: 0.0, hst_rate: 0.0 }
]

provinces_data.each do |province_data|
  Province.create!(province_data)
  puts "  Created: #{province_data[:name]} (#{province_data[:code]})"
end

puts "\nCreating product categories..."

# Categories for Nigerian building materials
categories_data = [
  { name: "Cement", description: "Various types of cement for construction including Portland cement, rapid-setting cement, and specialized blends" },
  { name: "Iron Rods & Steel", description: "Reinforcement bars, steel rods, and structural steel for construction" },
  { name: "Tiles & Flooring", description: "Floor tiles, wall tiles, ceramic, porcelain, and granite tiles" },
  { name: "Plumbing Materials", description: "Pipes, fittings, valves, water tanks, and plumbing fixtures" },
  { name: "Electrical Fittings", description: "Wires, cables, switches, sockets, circuit breakers, and electrical accessories" },
  { name: "Paints & Coatings", description: "Interior and exterior paints, primers, varnishes, and protective coatings" },
  { name: "Roofing Sheets", description: "Corrugated sheets, aluminum roofing, stone-coated roofing, and accessories" },
  { name: "Hardware & Tools", description: "Construction tools, fasteners, adhesives, and general hardware" }
]

categories = {}
categories_data.each do |category_data|
  category = Category.create!(category_data)
  categories[category.name] = category
  puts "  Created: #{category.name}"
end

puts "\nCreating products..."

# Products for each category
# Note: Prices are in Nigerian Naira (₦)

products_data = [
  # CEMENT (15 products)
  { name: "Dangote Cement 50kg", description: "High-quality Portland limestone cement, perfect for all construction needs. Dangote Cement is Nigeria's leading brand.", price: 4500.00, stock_quantity: 500, category: "Cement" },
  { name: "BUA Cement 50kg", description: "Premium quality cement for strong and durable construction. Made with the finest materials.", price: 4400.00, stock_quantity: 450, category: "Cement" },
  { name: "Lafarge Cement 50kg", description: "Trusted cement brand for residential and commercial construction. WAPCO quality guaranteed.", price: 4550.00, stock_quantity: 400, category: "Cement" },
  { name: "Elephant Cement 50kg", description: "Strong and reliable cement for foundations, columns, and general construction work.", price: 4350.00, stock_quantity: 350, category: "Cement" },
  { name: "Ibeto Cement 50kg", description: "Affordable quality cement from a trusted Nigerian manufacturer.", price: 4200.00, stock_quantity: 300, category: "Cement" },
  { name: "Ashaka Cement 50kg", description: "Premium Portland cement from Lafarge Africa, ideal for all building projects.", price: 4500.00, stock_quantity: 280, category: "Cement" },
  { name: "Unicem Cement 50kg", description: "High-performance cement for demanding construction applications.", price: 4450.00, stock_quantity: 250, category: "Cement" },
  { name: "Sokoto Cement 50kg", description: "Quality cement from Northern Nigeria, suitable for all types of construction.", price: 4300.00, stock_quantity: 220, category: "Cement" },
  { name: "Rapid Setting Cement 25kg", description: "Fast-setting cement for quick repairs and urgent construction work. Sets in 30 minutes.", price: 3500.00, stock_quantity: 150, category: "Cement", on_sale: true },
  { name: "White Cement 25kg", description: "Pure white cement for decorative work, tile fixing, and finishing.", price: 5500.00, stock_quantity: 100, category: "Cement" },
  { name: "Supaset Cement 50kg", description: "High early strength cement for projects requiring quick strength development.", price: 4800.00, stock_quantity: 180, category: "Cement" },
  { name: "Waterproof Cement 25kg", description: "Special cement blend with waterproofing additives for wet areas and basements.", price: 4200.00, stock_quantity: 120, category: "Cement" },
  { name: "Masonry Cement 50kg", description: "Specially formulated for bricklaying and block work with improved workability.", price: 4100.00, stock_quantity: 200, category: "Cement" },
  { name: "Oil Well Cement 50kg", description: "Specialized cement for oil well construction and deep foundation work.", price: 6500.00, stock_quantity: 80, category: "Cement" },
  { name: "Blended Cement 50kg", description: "Eco-friendly blended cement with reduced carbon footprint.", price: 4250.00, stock_quantity: 190, category: "Cement", new_arrival: true },

  # IRON RODS & STEEL (18 products)
  { name: "12mm Iron Rod (1 length)", description: "High-tensile steel reinforcement bar, 12mm diameter. Standard 6-meter length. For columns and beams.", price: 3500.00, stock_quantity: 800, category: "Iron Rods & Steel" },
  { name: "16mm Iron Rod (1 length)", description: "Heavy-duty reinforcement bar, 16mm diameter. Perfect for structural elements and foundations.", price: 5500.00, stock_quantity: 600, category: "Iron Rods & Steel" },
  { name: "10mm Iron Rod (1 length)", description: "Medium-duty steel rod, 10mm diameter. Ideal for slabs and light structural work.", price: 2800.00, stock_quantity: 1000, category: "Iron Rods & Steel" },
  { name: "8mm Iron Rod (1 length)", description: "Light reinforcement bar, 8mm diameter. Used for slab reinforcement and stirrups.", price: 1800.00, stock_quantity: 1200, category: "Iron Rods & Steel" },
  { name: "20mm Iron Rod (1 length)", description: "Extra heavy-duty rod for major structural elements. 20mm diameter, high tensile strength.", price: 8500.00, stock_quantity: 400, category: "Iron Rods & Steel" },
  { name: "25mm Iron Rod (1 length)", description: "Industrial-grade reinforcement for heavy construction and bridges.", price: 12000.00, stock_quantity: 200, category: "Iron Rods & Steel" },
  { name: "6mm Iron Rod (Bundle of 10)", description: "Small diameter rods for light work and stirrups. Bundle of 10 pieces.", price: 12000.00, stock_quantity: 300, category: "Iron Rods & Steel", on_sale: true },
  { name: "Binding Wire 1kg", description: "Soft annealed wire for tying reinforcement bars. 1kg roll.", price: 800.00, stock_quantity: 500, category: "Iron Rods & Steel" },
  { name: "Binding Wire 5kg", description: "Bulk pack binding wire for large projects. 5kg roll.", price: 3500.00, stock_quantity: 200, category: "Iron Rods & Steel" },
  { name: "Angle Iron 50x50x6mm (6m)", description: "Steel angle bar for structural support and framing. 6-meter length.", price: 8500.00, stock_quantity: 150, category: "Iron Rods & Steel" },
  { name: "Angle Iron 75x75x6mm (6m)", description: "Heavy-duty angle iron for major structural work.", price: 12500.00, stock_quantity: 100, category: "Iron Rods & Steel" },
  { name: "Steel Flat Bar 50x6mm (6m)", description: "Flat steel bar for gates, grills, and fabrication work.", price: 7500.00, stock_quantity: 180, category: "Iron Rods & Steel" },
  { name: "Square Pipe 50x50x3mm (6m)", description: "Hollow steel pipe for structural framing and support.", price: 9500.00, stock_quantity: 120, category: "Iron Rods & Steel" },
  { name: "Round Pipe 1 inch (6m)", description: "Steel tube for plumbing, railings, and general fabrication.", price: 4500.00, stock_quantity: 250, category: "Iron Rods & Steel" },
  { name: "C-Channel 100x50mm (6m)", description: "Steel C-channel for roofing purlins and structural support.", price: 11500.00, stock_quantity: 90, category: "Iron Rods & Steel" },
  { name: "Wire Mesh 4mm (2x3m sheet)", description: "Welded wire mesh for concrete reinforcement and fencing.", price: 8500.00, stock_quantity: 200, category: "Iron Rods & Steel" },
  { name: "Expanded Metal Mesh (1.2x2.4m)", description: "Expanded steel mesh for security doors and ventilation.", price: 6500.00, stock_quantity: 150, category: "Iron Rods & Steel" },
  { name: "Roofing Nails 3 inch (5kg)", description: "Galvanized nails for roofing sheet installation. 5kg pack.", price: 4500.00, stock_quantity: 300, category: "Iron Rods & Steel", new_arrival: true },

  # TILES & FLOORING (16 products)
  { name: "Porcelain Floor Tiles 60x60cm", description: "Premium porcelain tiles with marble finish. Box covers 1.44 sqm.", price: 8500.00, stock_quantity: 400, category: "Tiles & Flooring" },
  { name: "Ceramic Wall Tiles 30x60cm", description: "Glossy ceramic tiles perfect for kitchens and bathrooms. Box covers 1.08 sqm.", price: 4500.00, stock_quantity: 500, category: "Tiles & Flooring" },
  { name: "Granite Floor Tiles 60x60cm", description: "Natural granite look tiles, highly durable. Box covers 1.44 sqm.", price: 9500.00, stock_quantity: 350, category: "Tiles & Flooring" },
  { name: "Spanish Wall Tiles 25x40cm", description: "Imported decorative wall tiles with modern designs. Box covers 1.0 sqm.", price: 6500.00, stock_quantity: 300, category: "Tiles & Flooring", on_sale: true },
  { name: "Anti-Slip Floor Tiles 40x40cm", description: "Textured tiles for outdoor and wet areas. Box covers 0.96 sqm.", price: 5500.00, stock_quantity: 450, category: "Tiles & Flooring" },
  { name: "Mosaic Tiles 30x30cm", description: "Small decorative mosaic tiles for feature walls. Box covers 0.9 sqm.", price: 7500.00, stock_quantity: 200, category: "Tiles & Flooring" },
  { name: "Marble Effect Tiles 80x80cm", description: "Large format tiles with luxury marble look. Box covers 1.28 sqm.", price: 12500.00, stock_quantity: 150, category: "Tiles & Flooring" },
  { name: "Bathroom Floor Tiles 30x30cm", description: "Water-resistant tiles perfect for bathrooms. Box covers 0.9 sqm.", price: 4000.00, stock_quantity: 600, category: "Tiles & Flooring" },
  { name: "Kitchen Backsplash Tiles 20x30cm", description: "Decorative tiles for kitchen walls. Box covers 0.6 sqm.", price: 5500.00, stock_quantity: 280, category: "Tiles & Flooring" },
  { name: "Outdoor Paving Tiles 40x40cm", description: "Heavy-duty tiles for driveways and outdoor areas. Box covers 0.96 sqm.", price: 6500.00, stock_quantity: 320, category: "Tiles & Flooring" },
  { name: "3D Wall Panel Tiles", description: "Modern textured wall panels for accent walls. Box covers 1.5 sqm.", price: 15000.00, stock_quantity: 100, category: "Tiles & Flooring", new_arrival: true },
  { name: "Wood Effect Floor Tiles 20x100cm", description: "Porcelain tiles that look like hardwood. Box covers 1.2 sqm.", price: 11500.00, stock_quantity: 180, category: "Tiles & Flooring" },
  { name: "Subway Tiles 10x20cm", description: "Classic white subway tiles for modern interiors. Box covers 0.6 sqm.", price: 3500.00, stock_quantity: 400, category: "Tiles & Flooring" },
  { name: "Hexagon Floor Tiles 25x25cm", description: "Trendy geometric tiles for unique floor designs. Box covers 0.75 sqm.", price: 8500.00, stock_quantity: 220, category: "Tiles & Flooring" },
  { name: "Tile Adhesive 25kg", description: "High-quality cement-based tile adhesive for wall and floor installation.", price: 4500.00, stock_quantity: 500, category: "Tiles & Flooring" },
  { name: "Tile Grout 5kg (White)", description: "Premium grout for tile joints. Available in white and gray.", price: 2500.00, stock_quantity: 400, category: "Tiles & Flooring" },

  # PLUMBING MATERIALS (17 products)
  { name: "PVC Pipe 4 inch (3m)", description: "Heavy-duty PVC sewage pipe, 4 inch diameter, 3-meter length.", price: 3500.00, stock_quantity: 400, category: "Plumbing Materials" },
  { name: "PVC Pipe 3 inch (3m)", description: "PVC drainage pipe, 3 inch diameter for toilets and floor drains.", price: 2500.00, stock_quantity: 500, category: "Plumbing Materials" },
  { name: "PVC Pipe 2 inch (3m)", description: "Standard PVC pipe for sinks and bathroom drains.", price: 1500.00, stock_quantity: 600, category: "Plumbing Materials" },
  { name: "PPR Pipe 25mm (4m)", description: "Hot and cold water PPR pipe, 25mm diameter. German technology.", price: 2800.00, stock_quantity: 450, category: "Plumbing Materials" },
  { name: "PPR Pipe 20mm (4m)", description: "PPR pipe for water supply, 20mm diameter. Heat-resistant.", price: 2200.00, stock_quantity: 500, category: "Plumbing Materials" },
  { name: "Water Tank 500 Liters", description: "Overhead plastic water tank with cover and fittings. UV resistant.", price: 28000.00, stock_quantity: 80, category: "Plumbing Materials" },
  { name: "Water Tank 1000 Liters", description: "Large capacity water tank for homes and buildings.", price: 45000.00, stock_quantity: 50, category: "Plumbing Materials" },
  { name: "Water Tank 2000 Liters", description: "Extra large water storage tank for commercial use.", price: 75000.00, stock_quantity: 30, category: "Plumbing Materials" },
  { name: "Kitchen Sink Single Bowl", description: "Stainless steel kitchen sink with drain and fittings.", price: 15000.00, stock_quantity: 120, category: "Plumbing Materials" },
  { name: "Kitchen Sink Double Bowl", description: "Large double-bowl stainless steel kitchen sink.", price: 25000.00, stock_quantity: 80, category: "Plumbing Materials" },
  { name: "Shower Mixer Set", description: "Complete shower set with mixer, head, and hose. Chrome finish.", price: 18000.00, stock_quantity: 100, category: "Plumbing Materials", on_sale: true },
  { name: "Basin Mixer Tap", description: "Modern chrome basin tap with ceramic disc technology.", price: 8500.00, stock_quantity: 150, category: "Plumbing Materials" },
  { name: "WC Toilet Suite", description: "Complete close-coupled toilet with soft-close seat. Water-saving dual flush.", price: 45000.00, stock_quantity: 60, category: "Plumbing Materials" },
  { name: "Wall-Hung Basin", description: "Modern wall-mounted wash basin with pedestal. Ceramic.", price: 12000.00, stock_quantity: 90, category: "Plumbing Materials" },
  { name: "PVC Elbow 4 inch", description: "90-degree PVC elbow fitting for 4 inch pipes.", price: 800.00, stock_quantity: 300, category: "Plumbing Materials" },
  { name: "PVC Tee 4 inch", description: "T-junction fitting for 4 inch PVC pipes.", price: 1200.00, stock_quantity: 250, category: "Plumbing Materials" },
  { name: "Ball Valve 1 inch", description: "Brass ball valve for water shut-off. 1 inch connection.", price: 3500.00, stock_quantity: 200, category: "Plumbing Materials", new_arrival: true },

  # ELECTRICAL FITTINGS (16 products)
  { name: "Electrical Cable 2.5mm (100m roll)", description: "Single core copper cable for house wiring. 100-meter roll.", price: 18000.00, stock_quantity: 150, category: "Electrical Fittings" },
  { name: "Electrical Cable 4mm (100m roll)", description: "Heavy-duty copper cable for main distribution. 100-meter roll.", price: 28000.00, stock_quantity: 100, category: "Electrical Fittings" },
  { name: "Electrical Cable 1.5mm (100m roll)", description: "Standard cable for lighting circuits. 100-meter roll.", price: 12000.00, stock_quantity: 200, category: "Electrical Fittings" },
  { name: "Twin & Earth Cable 2.5mm (50m)", description: "Twin and earth cable for socket circuits. 50-meter roll.", price: 22000.00, stock_quantity: 120, category: "Electrical Fittings" },
  { name: "Flexible Cable 1.5mm (100m)", description: "Flexible cable for appliance connections and extensions.", price: 15000.00, stock_quantity: 180, category: "Electrical Fittings" },
  { name: "13A Socket Outlet (White)", description: "British standard 13A socket with switch. Single gang.", price: 1500.00, stock_quantity: 500, category: "Electrical Fittings" },
  { name: "13A Socket Outlet Double", description: "Twin 13A sockets in single mounting box. Space-saving.", price: 2500.00, stock_quantity: 400, category: "Electrical Fittings" },
  { name: "Light Switch 1 Gang", description: "Single gang light switch, white finish with rocker.", price: 800.00, stock_quantity: 600, category: "Electrical Fittings" },
  { name: "Light Switch 2 Gang", description: "Double gang light switch for controlling two lights.", price: 1200.00, stock_quantity: 500, category: "Electrical Fittings" },
  { name: "Circuit Breaker 32A", description: "MCB circuit breaker for socket protection. Single pole.", price: 2500.00, stock_quantity: 300, category: "Electrical Fittings" },
  { name: "Circuit Breaker 16A", description: "MCB for lighting circuits. Trip protection.", price: 2200.00, stock_quantity: 350, category: "Electrical Fittings" },
  { name: "Consumer Unit 8-Way", description: "Distribution board with 8-way MCB capacity. Metal enclosure.", price: 12000.00, stock_quantity: 80, category: "Electrical Fittings" },
  { name: "LED Bulb 9W (Warm White)", description: "Energy-saving LED bulb, equivalent to 60W incandescent.", price: 1500.00, stock_quantity: 400, category: "Electrical Fittings", on_sale: true },
  { name: "LED Bulb 15W (Cool White)", description: "High brightness LED bulb for large rooms.", price: 2200.00, stock_quantity: 350, category: "Electrical Fittings" },
  { name: "Ceiling Rose (White)", description: "Plastic ceiling rose for pendant light fittings.", price: 600.00, stock_quantity: 500, category: "Electrical Fittings" },
  { name: "Extension Socket 4-Way", description: "4-gang extension socket with surge protection and 3m cable.", price: 4500.00, stock_quantity: 200, category: "Electrical Fittings", new_arrival: true },

  # PAINTS & COATINGS (12 products)
  { name: "Emulsion Paint 20L (White)", description: "Premium acrylic emulsion for interior walls. Washable and durable.", price: 18000.00, stock_quantity: 200, category: "Paints & Coatings" },
  { name: "Emulsion Paint 20L (Cream)", description: "Smooth matt finish emulsion in popular cream shade.", price: 18500.00, stock_quantity: 180, category: "Paints & Coatings" },
  { name: "Gloss Paint 4L (White)", description: "Oil-based gloss paint for doors and windows. Long-lasting shine.", price: 8500.00, stock_quantity: 250, category: "Paints & Coatings" },
  { name: "Exterior Paint 20L", description: "Weather-resistant exterior wall paint. UV and fade resistant.", price: 22000.00, stock_quantity: 150, category: "Paints & Coatings" },
  { name: "Textured Paint 20L", description: "Decorative textured coating for feature walls.", price: 25000.00, stock_quantity: 100, category: "Paints & Coatings" },
  { name: "Wood Varnish 4L (Clear)", description: "Polyurethane varnish for wood protection and finishing.", price: 9500.00, stock_quantity: 180, category: "Paints & Coatings" },
  { name: "Metal Paint 4L (Black)", description: "Anti-rust metal paint for gates and railings.", price: 8000.00, stock_quantity: 200, category: "Paints & Coatings" },
  { name: "Primer Sealer 20L", description: "Undercoat primer for new walls. Improves paint adhesion.", price: 15000.00, stock_quantity: 160, category: "Paints & Coatings" },
  { name: "Floor Paint 20L (Gray)", description: "Heavy-duty epoxy floor paint for garages and workshops.", price: 28000.00, stock_quantity: 80, category: "Paints & Coatings", new_arrival: true },
  { name: "Roof Paint 20L (Terracotta)", description: "Waterproof coating for roofing sheets and tiles.", price: 24000.00, stock_quantity: 90, category: "Paints & Coatings" },
  { name: "Paint Roller Set", description: "Professional paint roller with tray and extension pole.", price: 3500.00, stock_quantity: 300, category: "Paints & Coatings" },
  { name: "Paint Brush Set (5pcs)", description: "Assorted paint brushes for cutting in and detail work.", price: 2500.00, stock_quantity: 400, category: "Paints & Coatings", on_sale: true },

  # ROOFING SHEETS (10 products)
  { name: "Aluminum Roofing Sheet 0.55mm", description: "Long-span aluminum roofing, 0.55mm gauge. 3.6m length.", price: 4500.00, stock_quantity: 500, category: "Roofing Sheets" },
  { name: "Aluminum Roofing Sheet 0.50mm", description: "Standard gauge aluminum sheet for roofing. 3.6m length.", price: 4200.00, stock_quantity: 600, category: "Roofing Sheets" },
  { name: "Stone-Coated Roofing (Classic)", description: "Premium stone-coated steel roofing with 50-year warranty.", price: 8500.00, stock_quantity: 300, category: "Roofing Sheets" },
  { name: "Stone-Coated Roofing (Milano)", description: "Luxury stone-coated tiles with Mediterranean design.", price: 9500.00, stock_quantity: 250, category: "Roofing Sheets" },
  { name: "Corrugated Iron Sheet 0.5mm", description: "Traditional corrugated galvanized iron roofing. 3.6m length.", price: 3500.00, stock_quantity: 400, category: "Roofing Sheets" },
  { name: "Longspan Roofing 0.55mm", description: "Wide-span roofing sheet for warehouses. 3.6m length.", price: 5500.00, stock_quantity: 350, category: "Roofing Sheets" },
  { name: "Polycarbonate Sheet 4mm", description: "Transparent roofing sheet for skylights and canopies. 2.1m x 6m.", price: 15000.00, stock_quantity: 100, category: "Roofing Sheets" },
  { name: "Ridge Cap Aluminum", description: "Aluminum ridge capping for roof peaks. 3m length.", price: 2500.00, stock_quantity: 300, category: "Roofing Sheets" },
  { name: "Valley Gutter Aluminum", description: "Valley gutter for roof water channeling. 3m length.", price: 2800.00, stock_quantity: 250, category: "Roofing Sheets" },
  { name: "Roofing Screws (Box of 100)", description: "Self-drilling screws with rubber washers for roofing sheets.", price: 2500.00, stock_quantity: 400, category: "Roofing Sheets", new_arrival: true },

  # HARDWARE & TOOLS (16 products)
  { name: "Wheelbarrow Heavy Duty", description: "Construction wheelbarrow with metal tray and pneumatic tire.", price: 18000.00, stock_quantity: 80, category: "Hardware & Tools" },
  { name: "Shovel Round Point", description: "Steel shovel for digging and earth moving. Wooden handle.", price: 4500.00, stock_quantity: 150, category: "Hardware & Tools" },
  { name: "Shovel Square Point", description: "Square shovel for scooping sand and cement. Heavy duty.", price: 4200.00, stock_quantity: 140, category: "Hardware & Tools" },
  { name: "Spirit Level 24 inch", description: "Aluminum spirit level for accurate leveling. 3 vials.", price: 3500.00, stock_quantity: 200, category: "Hardware & Tools" },
  { name: "Measuring Tape 10m", description: "Steel measuring tape with metric and imperial markings.", price: 2500.00, stock_quantity: 300, category: "Hardware & Tools" },
  { name: "Hammer Claw 16oz", description: "Steel claw hammer with fiberglass handle. For nails and demolition.", price: 3500.00, stock_quantity: 250, category: "Hardware & Tools" },
  { name: "Trowel Brick Laying", description: "Professional brick-laying trowel with wooden handle.", price: 2800.00, stock_quantity: 200, category: "Hardware & Tools" },
  { name: "Trowel Plastering", description: "Wide plastering trowel for wall finishing.", price: 2500.00, stock_quantity: 220, category: "Hardware & Tools" },
  { name: "Builder's Line & Pins", description: "Nylon builder's line with metal pins for setting out.", price: 1500.00, stock_quantity: 300, category: "Hardware & Tools" },
  { name: "Cement Mixer 200L", description: "Electric cement mixer for continuous concrete mixing.", price: 85000.00, stock_quantity: 25, category: "Hardware & Tools" },
  { name: "Bucket 15L (Plastic)", description: "Heavy-duty plastic bucket for water and materials.", price: 1500.00, stock_quantity: 400, category: "Hardware & Tools" },
  { name: "Safety Helmet (Yellow)", description: "Construction safety helmet with adjustable harness.", price: 2500.00, stock_quantity: 300, category: "Hardware & Tools" },
  { name: "Work Gloves (Leather)", description: "Leather palm work gloves for construction. Pack of 12 pairs.", price: 6000.00, stock_quantity: 150, category: "Hardware & Tools" },
  { name: "Safety Goggles", description: "Clear safety goggles for eye protection during work.", price: 1800.00, stock_quantity: 250, category: "Hardware & Tools" },
  { name: "Tile Cutter 24 inch", description: "Manual tile cutting machine for ceramic and porcelain tiles.", price: 15000.00, stock_quantity: 60, category: "Hardware & Tools", on_sale: true },
  { name: "Power Drill 13mm", description: "Electric drill with 13mm chuck. Variable speed control.", price: 18000.00, stock_quantity: 100, category: "Hardware & Tools", new_arrival: true }
]

# Create products and assign to categories
products_data.each_with_index do |product_data, index|
  category_name = product_data.delete(:category)
  category = categories[category_name]

  product = Product.create!(product_data)
  product.categories << category

  # Print progress every 10 products
  if (index + 1) % 10 == 0
    puts "  Created #{index + 1} products..."
  end
end

puts "  Created #{products_data.length} total products!"

puts "\n" + "="*60
puts "SEEDING COMPLETE!"
puts "="*60
puts "Summary:"
puts "  - Provinces: #{Province.count}"
puts "  - Categories: #{Category.count}"
puts "  - Products: #{Product.count}"
puts "  - Products on sale: #{Product.on_sale.count}"
puts "  - New arrivals: #{Product.new_arrivals.count}"
puts "="*60AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?