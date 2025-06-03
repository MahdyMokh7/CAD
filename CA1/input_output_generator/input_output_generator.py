import random
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

input_filename = 'data_input.txt'
output_filename = 'data_output.txt'
pdf_filename = 'output_report.pdf'

def process_number(x):
    binary_str = format(x, '016b')
    leading_zeros = 0
    for bit in binary_str:
        if bit == '0':
            leading_zeros += 1
        else:
            break
    start_index = leading_zeros
    end_index = start_index + 8
    if end_index > 16:
        end_index = 16
    eight_bits = binary_str[start_index:end_index]
    if eight_bits == '':
        eight_bits_value = 0
    else:
        eight_bits_value = int(eight_bits, 2)
    return leading_zeros, eight_bits_value

numbers = [random.randint(0, 65535) for _ in range(16)]

# Write to input file
with open(input_filename, 'w') as f_input:
    for number in numbers:
        binary_str = format(number, '016b')
        f_input.write(binary_str + '\n')

# Initialize PDF file
pdf = canvas.Canvas(pdf_filename, pagesize=letter)
pdf.setFont("Helvetica", 10)

# Start position of the text
x_pos = 40
y_pos = 750
line_height = 12

def write_to_pdf_and_print(text):
    global y_pos
    # Print the content to the console
    print(text)
    
    # Write the content to the PDF and check if the y-position is out of bounds
    pdf.drawString(x_pos, y_pos, text)
    y_pos -= line_height
    
    # If text goes beyond the bottom margin, start a new page
    if y_pos < 50:
        pdf.showPage()
        pdf.setFont("Helvetica", 10)
        y_pos = 750

# Process numbers and generate output
with open(output_filename, 'w') as f_output:
    binary_results = []
    hex_results = []

    for i in range(0, 16, 2):
        x1 = numbers[i]
        x2 = numbers[i + 1]
        leading_zeros1, eight_bits_value1 = process_number(x1)
        leading_zeros2, eight_bits_value2 = process_number(x2)
        total_leading_zeros = leading_zeros1 + leading_zeros2
        product = eight_bits_value1 * eight_bits_value2
        product = product & 0xFFFF
        product_binary_str = format(product, '016b')
        product_hex_str = format(product, '04X')
        left_padding = '0' * total_leading_zeros
        right_padding = '0' * (16 - total_leading_zeros)
        final_32_bit_str = left_padding + product_binary_str + right_padding
        final_32_bit_hex_str = format(int(final_32_bit_str, 2), '08X')

        # Store binary and hex results separately
        binary_results.append(final_32_bit_str)
        hex_results.append(final_32_bit_hex_str)

        # Exact and approximate values for PDF and print output
        exact_product_decimal_str = f"{x1 * x2:,}"
        product_decimal_str = f"{product:,}"
        final_32_bit_value = int(final_32_bit_str, 2)
        final_32_bit_decimal_str = f"{final_32_bit_value:,}"
        error = (((x1 * x2) - final_32_bit_value) / (x1 * x2))

        # Write to PDF and print to console
        write_to_pdf_and_print(f"Pair {i//2 + 1}:")
        write_to_pdf_and_print(f"  input 1: {format(x1, '016b')} (Decimal: {x1:,})")
        write_to_pdf_and_print(f"    Worthless zeros: {leading_zeros1}")
        write_to_pdf_and_print(f"    Efficient 8 bits: {format(eight_bits_value1, '08b')} (Decimal: {eight_bits_value1})")
        write_to_pdf_and_print("")
        write_to_pdf_and_print(f"  input 2: {format(x2, '016b')} (Decimal: {x2:,})")
        write_to_pdf_and_print(f"    Worthless zeros: {leading_zeros2}")
        write_to_pdf_and_print(f"    Efficient 8 bits: {format(eight_bits_value2, '08b')} (Decimal: {eight_bits_value2})")
        write_to_pdf_and_print("")
        write_to_pdf_and_print(f"  Total Worthless zeros added to left:             {total_leading_zeros}")
        write_to_pdf_and_print(f"  Product of Efficient 8-bit numbers:              {product_binary_str} (Decimal: {product_decimal_str})")
        write_to_pdf_and_print(f"  Final 32-bit Approximate multiplication:         {final_32_bit_str}")
        write_to_pdf_and_print(f"  Final 32-bit decimal Approximate multiplication: {final_32_bit_decimal_str}")
        write_to_pdf_and_print(f"  Exact multiplication:                            {exact_product_decimal_str}")
        write_to_pdf_and_print(f"  Error percent:                                   {error:.5f}%")
        write_to_pdf_and_print("")
        write_to_pdf_and_print("-" * 80)
        write_to_pdf_and_print("")

    # Write binary results to the output file first
    for binary_result in binary_results:
        f_output.write(binary_result + '\n')

    # Write hex results to the output file in the next lines
    for hex_result in hex_results:
        f_output.write(hex_result + '\n')

# Save the PDF
pdf.showPage()  # Ensure the last page is finalized
pdf.save()

print("Processing and report generation completed. The output has been written to the PDF file and text file.")
