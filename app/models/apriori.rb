class Apriori < ApplicationRecord
  def compare_hash
    order_detail = OrderDetail.all
    order = Order.all
    h1 = {}
    order.each do |o|
      list_item = []
      order_detail.each do |od|
        if od.order_id == o.id
          list_item << (od.product.id)
        end
      end
      newkey = o.id
      h1[newkey] = list_item
    end
    return h1
  end

  def initialize_asso(h1)
    arr = h1.values
    asso = []
    arr.each do |sub|
      sub.each do |item|
        puts "item: " + item.to_s
        if !asso.include?(item)
          asso << item
        end
      end
    end
    return asso
  end

  def generate_combination(k, arr)
    arr.combination(k).to_a
  end

  def compare(combinations, h1)
    pop_out = []
    combinations.each do |combo|
      count = 0
      h1.each do |h|
        if (combo - h.second).empty?
          count += 1
        end
      end
      min_sup = Order.all.count * 0.2
      if count < min_sup.to_i
        pop_out << combo
      end
    end
    return (combinations - pop_out)
  end

  def main
    k = 1
    h1 = compare_hash
    result = initialize_asso h1
    puts result
    while (true)
      puts "Number of loops" + k.to_s

      combinations = result.combination(k).to_a

      if combinations.empty?
        break
      end
      combinations = compare(combinations, h1)

      if (combinations.empty?)
        if(k == 1)
          result = []
        end
        break
      else
        temp = []
        combinations.each do |combo|
          combo.each do |item|
            if !temp.include?(item)
              temp << item
            end
          end
        end
        result = temp
        k += 1
      end
    end
    return result
  end
end
