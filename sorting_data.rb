      
      unsorted = "all_data.txt"
      sorted = {} 
      data = []
      
      # # # # # # # # # # # # # # # # # # # # # # # # #
      # # # # # #      W O R K P I E C E    # # # # # #
      # # # # # # # # # # # # # # # # # # # # # # # # #
      
      
      puts "\nWORKPIECE\n"
      
      
      puts "\nCONVERTING THE DATA TO THE ARRAYS OF STRINGS ['', '', '']\n\n"
      File.readlines(unsorted).each_with_index do |line, i| 
        # puts "linea : #{line.to_s.inspect}"
        # puts "#{line}".class# => String
        
        words = line.split(",") 
        
        # puts words.inspect #=> ["5.16375", "4.99757", "138.276"]
       
        data << words
      
      end
      
      puts "\nACCESS TO THE VALUES (ORIGINAL DATA)\n\n"
      for i in 0..(data.length -  1) do
          x = data[i][0]  # saves value of x from array to X variable
          y = data[i][1]  # saves value of y from array to Y variable
          t = data[i][2]  # saves value of t from array to T variable
          # puts "#{x.inspect} \t y #{y.inspect} \t T #{t.inspect}"
      end
      
      
      # ordering X data
      puts "\nORDERED DATA (ARRAY OF ARRAYS OF STRINGS): \n\n"
      ordered = data.sort_by.with_index{|_, i| data[i]}
      
      

                   #      # # #    U N C O M M E N T if wanted to see the table of ALL ORDERED VALUES
                   #        puts "\nACCESS TO THE VALUES (ORDERED DATA) \n\n"
                   #        for i in 0..(ordered.length-1) do
                   #            x = ordered[i][0]
                   #            y = ordered[i][1]
                   #            t = ordered[i][2]
                   #             puts "#{x.to_f}\t\t#{y.to_f}\t\t#{t.to_f}"
                   #        end
                                      
      
      
      # SAVING ORDERED DATA TO THE NEW FILE
      # kateryna@MacBook-Pro:simulation_data_order:> ruby sorting_data.rb > out.txt
      
      File.open("ordered_data.txt", 'w+') do |file|
         file.write(ordered.inspect)
      end
 
 
      # CHOOSING THE INTERVALS OF X
     
      puts "DATA IN CHOSEN INTERVAL\n "
     
      limit_1 = 3.6
      limit_2 = 4.6
      x_array = []
      y_array = []
      t_array = []
      x_dist  = []
      y_dist  = []
      t_mean  = []
      # temp    = 
      
      for i in 0..(ordered.length - 1) do   
         x = ordered[i][0].to_f
         y = ordered[i][1].to_f
         t = ordered[i][2].to_f
         
         # puts x.inspect
         
         if x >= limit_1 && x <= limit_2 
            puts "#{x} #{y} #{t}"    
           
            # saving values of x, y, t as arrays x[], y[], t[] to get access to the previuos/next values to calculate sum
            x_array << x
            y_array << y
            t_array << t
            
            # puts x_array.inspect
            # puts y_array.inspect
            # puts t_array.inspect
       
          end #if
       
      end #for
    
    
      ###  PREVIOUS AND NEXT VALUES
    
      # X_DISTANCE
      puts " "
      x_array.each_cons(2) do |x_prev_element, x_next_element|   
         # puts "#{x_prev_element} is followed by #{x_next_element}"
         x_distance = ( x_next_element - x_prev_element)     
         # puts "x_dist #{x_distance.round(3)}"
         
         x_dist << x_distance.round(3)
         
      end #each.cons
    
    
                   
                 #  # Y_DISTANCE CANNOT BE CALCULATED BECAUSE IN IT NOT ORDERED - ONLY X IS ORDERED
                 #  puts " "
                 #  y_array.each_cons(2) do |y_prev_element, y_next_element|
                 #     y_distance = ( y_next_element - y_prev_element)     
                 #     puts "y_distance #{y_distance.round(5)}"
                 #    
                 #    y_dist << y_distance.round(5)
                 #  end #each.cons
               
      

      # CALCULATING TEMPERATURE DIFFERENCE
      puts " "
      t_array.each_cons(2) do |t_prev_element, t_next_element|   
         # puts "#{t_prev_element} is followed by #{t_next_element}"
          t_difference = ( t_next_element + t_prev_element ) / 2   
          # puts "t_difference #{t_difference.round(5)}"
         
          t_mean << t_difference.round(3)
         
      end #each.cons
      
      
      
                 # # #   U N C O M M E N T if wanted to see the arrays of values of x_dist and t_mean
                
                 # puts "\nx_distance, mm: \n#{x_dist}\n"
                 # puts "\nT_mean, C: \n#{t_mean},\nn_values_of_T_mean = #{t_mean.length}\n\n"
      
      
      
      # SUM OF DISTANCE AND TEMPERATURE

      # example
      #  a   = [123,321,12389]
      #  sum = 0
      #  a.each{ |a| sum += a}
      #  puts sum => 12833
      
      
      #  sum of all x-distancies 
      x_dist_sum = 0  
      x_dist.each{ |x_dist| x_dist_sum += x_dist }
      puts "x_dist_sum, mm #{x_dist_sum.round(3)}"
      
      
      #  sum of all temperatures
      t_mean_sum = 0  
      t_mean.each{ |t_mean| t_mean_sum += t_mean }
      puts "t_mean_sum, C #{t_mean_sum.round(3)}"    
      
      
      
      # AVERAGE TEMPERATURE
       
      # V 1:
      temp_average = (t_mean_sum * x_dist_sum) / t_mean.length
      puts "temp_average, C = #{t_mean_sum.round(3)} / #{t_mean.length} * #{x_dist_sum.round(3)} = #{temp_average.round(3)} "     
        
        
       # V 2:
       # integral: f(x)dx ot Tsum(x)dx, where interval lies between x0 = limit_1 and xn = limit_2
       
            # x0 = limit_1
            # xn = limit_2
            # temp_0 = (t_mean_sum.round(3) / t_mean.length) * x0
            # temp_n = (t_mean_sum.round(3) / t_mean.length) * xn
            # temp_average = temp_n.round(3) - temp_0.round(3)
            # 
            # puts "temp_n, C #{temp_n.round(3)}; \ntemp_0, C #{temp_0.round(3)}"
            # puts "temp_average = temp_n - temp_0 = #{temp_average.round(3)}"
                
     
     
     
     
       # # # # # # # # # # # # # # # # # # # # # # # # #
       # # # # # # # # #      T O O L    # # # # # # # #
       # # # # # # # # # # # # # # # # # # # # # # # # #
     
