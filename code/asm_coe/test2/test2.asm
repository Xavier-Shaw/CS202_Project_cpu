.data 0x0000
	space: .space 160
	
.text 0x0000
start: 
	lui   $1,0xFFFF			
        ori   $28,$1,0xF000
	add $22, $0, $0	
	ori  $26, $26, 1
	addi $21, $21, 128
	lui $3,  0x02FF
	ori $3, $3, 0xFFFF		# $7 = 0010 1111 1111 1111 1111 1111 1111
        #8�żĴ�������ʼ��ַbase��ȫ0����9�żĴ�����space����???
judge:
	lw    $1,0xC72($28)
	sw   $1,0xC62($28)	#���ͼ������ͻ�һֱͣ���⣿����
	beq $22, $0, confirm_case_even

confirm_case_odd:
	lw $24, 0xC72($28)
	srl $24, $24, 1
	and $25, $24, $26
	bne $25, $26, judge
	add $22, $0, $0	#$22 = 0
	beq $0, $0, do_case

confirm_case_even:
	lw $24, 0xC72($28)
	and $25, $24, $26
	bne $25, $26, judge
	add $22, $0, $26	#$22 = 1
	beq $0, $0, do_case


do_case:
	sw $0, 0xC60($28)
	srl $1, $1, 5
	add $27, $0, $0	#����27
	beq $1, $27, load_data #27�żĴ��������������ֵ�����ж�beq����ʼ���Ϊ000
	addi $27, $0, 1
	beq $1, $27, sort_1
	addi $27, $27, 1
	beq $1, $27, load_2
	addi $27, $27, 1
	beq $1, $27, sort_3
	addi $27, $27, 1
	beq $1, $27, max_minus_min_1
	addi $27, $27, 1
	beq $1, $27, max_minus_min_3
	addi $27, $27, 1
	beq $1, $27, low_8_bit
	addi $27, $27, 1
	beq $1, $27, show_msg
	
load_data:
	lw   $1,0xC70($28)	#����Ҫ��������ĸ���				
	sw   $1,0xC60($28)
judge_num_in:
	lw $24, 0xC72($28)
	sw $24, 0xC62($28)
	beq $22, $0, even_num_in

odd_num_in:
	lw $24, 0xC72($28)
	srl $24, $24, 1
	and $25, $24, $26
	bne $25, $26, load_data
	add $22, $0, $0	# $22 = 0
	beq $0, $0, confirm_num

even_num_in:
	lw $24, 0xC72($28)
	and $25, $24, $26
	bne $25, $26, load_data
	add $22, $0, $26	# $22 = 1
	beq $0, $0, confirm_num


confirm_num:
	add $9, $0, $1		#9�żĴ�����Ҫ��������ĸ���
	addi $10, $0, 0		#10�żĴ����浱ǰ��������ڼ�����
	addi $11, $0, 0		#11�żĴ����浱ǰ��ʼ��ַ
	addi $12, $0, 40		#12�żĴ�����1�����ݼ���ʼ��ַ
load_loop: 
	lw $1,0xC70($28)				
	sw $1,0xC60($28)
	beq $22, $0, even_input_in

odd_input_in:
	lw $24, 0xC72($28)
	sw $24, 0xC62($28)
	srl $24, $24, 1
	and $25, $24, $26
	bne $25, $26, load_loop
	and $22, $0, $0	# $22 = 0
	beq $0, $0, store_input

even_input_in:
	lw $24, 0xC72($28)
	sw $24, 0xC62($28)
	and $25, $24, $26
	bne $25, $26, load_loop
	add $22, $0, $26    	# $22 = 1	
	beq $0, $0, store_input

store_input:
	sw $1, 0($11)
	sw $1, 0($12)		#�Ȱ�ͬ����˳�����1�����ݼ��У�������һ��������������
	addi $11, $11, 4	#��ǰ��ַ+1byte/+4bit
	addi $12, $12, 4
	addi $10, $10, 1
	bne $9, $10, load_loop  

	addi $10, $0, 0			#��ԭ����
	addi $11, $0, 0
	addi $12, $0, 0
	beq $0, $0, judge

sort_1:
	#10�żĴ�������������11�żĴ������ڲ������12�żĴ�����a[i]��13�żĴ�����a[i+1]��14�żĴ�����a[i]��ַ��a[i+1]��ַΪa[i]��ַ+4

	add $11, $0, $zero	# ÿ��ִ�����ѭ�������ڲ�ѭ����ѭ��������Ϊ0
	sort_1_loop1:
		add $14, $0, $11
		sll $14, $14, 2		#x4���Ƕ�Ӧ��byte�ĵ�ַ
		addi $14, $14, 40
		lw $12, 0($14)
		lw $13, 4($14)		#��ȡa[i]��a[i+1]
		
		#15�żĴ����ж�a[i]�Ƿ����a[i+1]
		sltu $15, $12, $13	#a[i] < a[i+1] -- $15==1
		bne $15, $0, sort_1_skip	#��ai < ai+1������skip�� �����ڵ��ڣ��򽻻�ֵ
		sw $12, 4($14)
		sw $13, 0($14)
	sort_1_skip:
		addi $11, $11, 1	#�ڲ�����������ж��Ƿ�����ѭ������
		addi $16, $11, 1	#�ж����ڴ����ڼ��������±�Ϊ0 -> ��1������
		sub $17, $9, $10
		bne $16, $17, sort_1_loop1	#�ж��ڲ��Ƿ�����
		addi $10, $10, 1
		sub $18, $9, $26
		bne $10, $18, sort_1	#�ж��������Ƿ�����
	addi $10, $0, 0	#��ԭ����
	addi $11, $0, 0
	addi $12, $0, 0
	addi $13, $0, 0
	addi $14, $0, 0
	addi $15, $0, 0
	addi $16, $0, 0
	addi $17, $0, 0
	addi $18, $0, 0
	beq $0, $0, judge
		
load_2:
	addi $10, $0, 0		#10�żĴ����浱ǰ���ڴ���ڼ�����
	addi $11, $0, 80	#11�żĴ�����2�����ݼ�����ʼ��ַ
	addi $12, $0, 0		#12�żĴ�����0�����ݼ�����ʼ��ַ
	addi $15, $0, 120		#15�żĴ�����3�����ݼ�����ʼ��ַ��һ����룬�ں��������������
	load2_loop:
		addi $10, $10, 1
		
		lw $13, 0($12)	#13�żĴ�����0�����ݼ��������Ķ�Ӧ��
		slti $14, $13, 128	#14�żĴ����ж�13�żĴ������������Ǹ����������������14�żĴ���=1
		beq $14, $26, positive
		beq $14, $0, negative
		positive:
			beq $0, $0, restore
		negative:					#21�żĴ��� = 128  ����$13 - 128��ȥ����λ Ȼ����128 - $13��ȡ�����ֵ Ȼ����Ϸ���λ
			sub $13, $13, $21		# $13 = $13 - $21
			sub $13, $21, $13		# $13 = $21 - $13
			ori $13, $13, 0x80		# $13 = $13 | 1000 0000 
			beq $0, $0, restore
		restore:
			sw $13, 0($11)
			sw $13, 0($15)
			addi $11, $11, 4	#��ǰ��ַ+1byte/+4bit
			addi $15, $15, 4
			addi $12, $12, 4
			bne $9, $10, load2_loop
	addi $10, $0, 0	#��ԭ����
	addi $11, $0, 0	
	addi $12, $0, 0
	addi $13, $0, 0
	addi $14, $0, 0
	addi $15, $0, 0
	beq $0, $0, judge

sort_3:
	#10�żĴ�������������11�żĴ������ڲ������12�żĴ�����a[i]��13�żĴ�����a[i+1]��14�żĴ�����a[i]��ַ��a[i+1]��ַΪa[i]��ַ+4
	add $11, $0, $zero	# ÿ��ִ�����ѭ�������ڲ�ѭ����ѭ��������Ϊ0
	sort_3_loop1:
		add $14, $0, $11
		sll $14, $14, 2		#x4���Ƕ�Ӧ��byte�ĵ�ַ
		addi $14, $14, 120
		lw $12, 0($14)
		lw $13, 4($14)		#��ȡa[i]��a[i+1]
		andi $19, $12, 128	#19�Ŷ�ȡa[i]�ķ���λ
		andi $20, $13, 128	#20�Ŷ�ȡa[i+1]�ķ���λ
		
		#15�żĴ����ж�a[i]�Ƿ����a[i+1]����Ҫ���е���a[i]��a[i+1]��С��0���Լ�a[i]��a[i+1]���
		bne $19, $20, compare_different
		and $4, $19, $20	#4�żĴ����ж��ǲ��Ƕ�Ϊ����
		beq $4, $21, compare_all_negative
		beq $0, $0, compare_normal

		compare_different:	#a[i]��a[i+1]���
			add $15, $15, $26
			beq $19, $21, compare_judge	#��a[i]<0, a[i+1]>=0���������жϣ�$15 == 1
			add $15, $0, $0		#��a[i]>=0, a[i+1]<0������뽻��
			beq $0, $0, compare_judge
		compare_all_negative:
			slt $15, $13, $12
			beq $0, $0, compare_judge
		compare_normal:
			slt $15, $12, $13	#a[i] < a[i+1] -- $15==1

		compare_judge:
			bne $15, $0, sort_3_skip	#��ai < ai+1������skip�� �����ڵ��ڣ��򽻻�ֵ
			sw $12, 4($14)
			sw $13, 0($14)
	sort_3_skip:
		addi $11, $11, 1	#�ڲ�����������ж��Ƿ�����ѭ������
		addi $16, $11, 1	#�ж����ڴ����ڼ��������±�Ϊ0 -> ��1������
		sub $17, $9, $10
		bne $16, $17, sort_3_loop1	#�ж��ڲ��Ƿ�����
		addi $10, $10, 1
		sub $18, $9, $26
		bne $10, $18, sort_3	#�ж��������Ƿ�����
	addi $10, $0, 0	#��ԭ����
	addi $11, $0, 0
	addi $12, $0, 0
	addi $13, $0, 0
	addi $14, $0, 0
	addi $15, $0, 0
	addi $16, $0, 0
	addi $17, $0, 0
	addi $18, $0, 0
	beq $0, $0, judge
	

max_minus_min_1:
	addi $10, $0, 0		#10�żĴ�������ǰ���ڴ���ڼ������������жϵ�ǰ���ǲ������ֵ��
	addi $11, $0, 36	#11�żĴ����浱ǰ��������ĵ�ַ
	lw $12, 4($11)		#12�żĴ��������ݼ�1����Сֵ
	find_max:
		addi $10, $10, 1
		addi $11, $11, 4	#���µ�ǰ���ĵ�ַ
		bne $10, $9, find_max	
	lw $13, 0($11)		#13�żĴ��������ݼ�1�����ֵ
	subu $13, $13, $12	#1�����ݼ����޷�����
	sw $13, 0xC60($28)
	#��ԭ����
	addi $10, $0, 0
	addi $11, $0, 0
	addi $12, $0, 0
	addi $13, $0, 0
	beq $0, $0, judge

max_minus_min_3:
	addi $10, $0, 0		#10�żĴ�������ǰ���ڴ���ڼ������������жϵ�ǰ���ǲ������ֵ��
	addi $11, $0, 116	#11�żĴ����浱ǰ��������ĵ�ַ
	lw $12, 4($11)		#12�żĴ��������ݼ�1����Сֵ
	find_max3:
		addi $10, $10, 1
		addi $11, $11, 4	#���µ�ǰ���ĵ�ַ
		bne $10, $9, find_max3	
	lw $13, 0($11)		#13�żĴ��������ݼ�1�����ֵ
	sub $13, $13, $12	#3�����ݼ����з�����
	sw $13, 0xC60($28)
	#��ԭ����
	addi $10, $0, 0
	addi $11, $0, 0
	addi $12, $0, 0
	addi $13, $0, 0
	beq $0, $0, judge


low_8_bit:
	lw    $1,0xC70($28)
	sw   $1,0xC60($28)	#����������ݼ���Ų���ʾ��led�ϣ�sw0, sw1�İ������룡����
	beq $22, $0, even_8_bit

odd_8_bit:
	lw $24, 0xC72($28)
	sw $24, 0xC62($28)
	srl $24, $24, 1
	and $25, $24, $26
	bne $25, $26, low_8_bit
	add $22, $0, $0	#$22 = 0
	beq $0, $0, confirm_8_bit

even_8_bit:
	lw $24, 0xC72($28)
	sw $24, 0xC62($28)
	and $25, $24, $26
	bne $25, $26, low_8_bit
	add $22, $0, $26	#$22 = 1
	beq $0, $0, confirm_8_bit

confirm_8_bit:
	add $13, $0, $0	#����13�żĴ���
	andi $1, $1, 3		#��ȥsw23,sw22,sw21������
	addi $10, $0, 1		#10�żĴ����� �ж�������ǵڼ������ݼ� ������
	beq $10, $1, deal_1
	addi $10, $10, 1
	beq $10, $1, deal_2
	addi $10, $10, 1
	beq $10, $1, deal_3	#δ�Բ��Ϸ���������жϣ�����һ��Ҫ��֤��������ݼ������1��2��3�е�һ��
	
	deal_1:
		addi $11, $0, 36		#11�żĴ�����1�����ݼ�����ʼ��ַ
		lw $1,0xC70($28)
		sw $1,0xC60($28)	#��ȡҪ�������ֵ��±꣨��0��ʼ�������������+1�ĳɴ�1��ʼ��
		beq $22, $0, even_deal_1

	odd_deal_1:
		lw $24, 0xC72($28)
		sw $24, 0xC62($28)
		srl $24, $24, 1
		and $25, $24, $26
		bne $25, $26, deal_1
		add $22, $0, $0	#$22 = 0
		beq $0, $0, confirm_deal_1

	even_deal_1:
		lw $24, 0xC72($28)
		sw $24, 0xC62($28)
		and $25, $24, $26
		bne $25, $26, deal_1
		add $22, $0, $26	#$22 = 1
		beq $0, $0, confirm_deal_1
		
	
	confirm_deal_1:
		addi $1, $1, 1
		addi $12, $0, 0		#12�żĴ����浱ǰ���ڶ��ڼ�����
		find_num1:
			addi $12, $12, 1
			addi $11, $11, 4
			bne $12, $1, find_num1
		lw $13, 0($11)		#13�żĴ������������
		andi $13, $13, 255	#ȡ��8bit
		beq $0, $0, handle

	deal_2:
		addi $11, $0, 76		#11�żĴ�����2�����ݼ�����ʼ��ַ
		lw $1,0xC70($28)
		sw $1,0xC60($28)	#��ȡҪ�������ֵ��±꣨��0��ʼ�������������+1�ĳɴ�1��ʼ��
		beq $22, $0, even_deal_2

	odd_deal_2:
		lw $24, 0xC72($28)
		sw $24, 0xC62($28)
		srl $24, $24, 1
		and $25, $24, $26
		bne $25, $26, deal_2
		add $22, $0, $0	#$22 = 0
		beq $0, $0, confirm_deal_2

	even_deal_2:
		lw $24, 0xC72($28)
		sw $24, 0xC62($28)
		and $25, $24, $26
		bne $25, $26, deal_2
		add $22, $0, $26	#$22 = 1
		beq $0, $0, confirm_deal_2
		
	confirm_deal_2:
		addi $1, $1, 1
		addi $12, $0, 0		#12�żĴ����浱ǰ���ڶ��ڼ�����
		find_num2:
			addi $12, $12, 1
			addi $11, $11, 4
			bne $12, $1, find_num2
		lw $13, 0($11)		#13�żĴ������������
		andi $13, $13, 255	#ȡ��8bit
		beq $0, $0, handle

	deal_3:
		addi $11, $0, 116		#11�żĴ�����3�����ݼ�����ʼ��ַ
		lw $1,0xC70($28)
		sw $1,0xC60($28)	#��ȡҪ�������ֵ��±꣨��0��ʼ�������������+1�ĳɴ�1��ʼ��
		beq $22, $0, even_deal_3

	odd_deal_3:
		lw $24, 0xC72($28)
		sw $24, 0xC62($28)
		srl $24, $24, 1
		and $25, $24, $26
		bne $25, $26, deal_3
		add $22, $0, $0	#$22 = 0
		beq $0, $0, confirm_deal_3

	even_deal_3:
		lw $24, 0xC72($28)
		sw $24, 0xC62($28)
		and $25, $24, $26
		bne $25, $26, deal_3
		add $22, $0, $26	#$22 = 1
		beq $0, $0, confirm_deal_3
		
	
	confirm_deal_3:		
		addi $1, $1, 1
		addi $12, $0, 0		#12�żĴ����浱ǰ���ڶ��ڼ�����
		find_num3:
			addi $12, $12, 1
			addi $11, $11, 4
			bne $12, $1, find_num3
		lw $13, 0($11)		#13�żĴ������������
		andi $13, $13, 255	#ȡ��8bit
		beq $0, $0, handle
	
	handle:
		sw $13, 0xC60($28)
		add $13, $0, $0
		beq $0, $0, judge
		
show_msg:
		lw $1, 0xC70($28)
		sw $1, 0xC60($28)
		addi $1, $1, 1
		beq $22, $0, even_show_in

	odd_show_in:
		lw $24, 0xC72($28)
		sw $24, 0xC62($28)
		srl $24, $24, 1
		and $25, $24, $26
		bne $25, $26, show_msg
		add $22, $0, $0	#$22 = 0
		beq $0, $0, confirm_msg

	even_show_in:
		lw $24, 0xC72($28)
		sw $24, 0xC62($28)
		and $25, $24, $26
		bne $25, $26, show_msg
		add $22, $0, $26	#$22 = 1	
		beq $0, $0, confirm_msg

	confirm_msg:
		#��show���ݼ�0
		addi $10, $0, 0		# 1�żĴ����� Ԫ���±�	 10�żĴ���: ���ڴ�����ǵڼ�����  11�żĴ��������������ݵĵ�ַ	13�żĴ�����������ֵ
		addi $11, $0, -4
		
		find_msg_1:
		addi $10, $10, 1
		addi $11, $11, 4
		bne $10, $1, find_msg_1
	
		lw $13, 0($11)
		andi $13, $13, 255
		sw $13, 0xC60($28)
		add $13, $0, $0
		beq $0, $0, msg_loop_1

	change_show:
		#��show���ݼ�2
		addi $10, $0, 0		# 1�żĴ����� Ԫ���±�	3�żĴ���������ʾʱ��	 10�żĴ���: ���ڴ�����ǵڼ�����  11�żĴ��������������ݵĵ�ַ	13�żĴ�����������ֵ
		addi $11, $0, 76
		
		find_msg_2:
		addi $10, $10, 1
		addi $11, $11, 4
		bne $10, $1, find_msg_2
	
		lw $13, 0($11)
		andi $13, $13, 255
		sw $13, 0xC60($28)
		add $13, $0, $0
		beq $0, $0, msg_loop_2	

	continue:
		beq $22, $0, even_no_show
	
	odd_no_show:
		lw $24, 0xC72($28)
		sw $24, 0xC62($28)
		srl $24, $24, 1
		and $25, $24, $26
		bne $25, $26, confirm_msg
		add $22, $0, $0	# $22 = 0
		beq $0, $0, exit

	even_no_show:
		lw $24, 0xC72($28)
		sw $24, 0xC62($28)
		and $25, $24, $26
		bne $25, $26, confirm_msg
		add $22, $0, $26	# $22 = 1
		beq $0, $0,  exit
		

	msg_loop_1:
		add $5, $0, $0
		until_five_sec_1:
		addi $5, $5, 1
		bne $5, $3, until_five_sec_1
		beq $0, $0, change_show

	msg_loop_2:
		add $5, $0, $0
		until_five_sec_2:
		addi $5, $5, 1
		bne $5, $3, until_five_sec_2
		beq $0, $0, continue

	exit:
		sw $0, 0xC60($28)
		beq $0, $0, judge
