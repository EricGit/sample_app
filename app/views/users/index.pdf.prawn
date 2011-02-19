pdf.move_down 70

# Add the font style and size
pdf.font "Helvetica"
pdf.font_size 18
pdf.text_box "Invoice ", :align => :right

@users.each do |user|
   #pdf.separator
   pdf.text user[:name]
   pdf.move_down 20 
end

pdf.font_size 14
pdf.text "Below you can find your order details!", :align=> :center