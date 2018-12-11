defmodule Calculator do

  def convert_values(statement) do
    result = Float.parse(statement);

    if result == :error do
      statement
    else
      elem(result, 0)
    end
  end

  def operate(operator, val1, val2) do
    cond do
      operator == "+" ->
        val1 + val2

      operator == "-" ->
        val1 - val2

      operator == "*" ->
        val1 * val2

      operator == "/" ->
        val1 / val2

      operator == "^" ->
        :math.pow(val1, val2)

      true ->
        raise ArgumentError, message: "Operation not supported, please wait for v2.0 release"

    end

  end

  def cumulate(current_val, accumulation) do
    val = current_val

    cond do
      accumulation[:value] == nil ->

        unless is_float(val) do
          raise ArgumentError, message: "First value must be a number"
        end

        %{ value: val, operator: nil }

      is_float(val) ->

        operator = accumulation[:operator]
        original_value = accumulation[:value]

        if operator == nil do
          raise ArgumentError, message: "Two values cannot be one after another, put an operator between"
        end

        if original_value == nil do
          raise ArgumentError, message: "Error!"
        end

        new_value = operate(operator, original_value, val)

        %{ value: new_value, operator: nil }

      is_bitstring(val) ->

        %{ value: accumulation[:value], operator: val }

      true ->

        raise ArgumentError, message: "Invalid operation not permitted"

    end


  end

  def calculate(calc_array) do
    Enum.reduce(calc_array, %{}, &cumulate/2)
  end

  def evaluate(statement) do
    if Enum.at(statement, 0) == "q" do
      :stop
    else
      Enum.map(statement, &convert_values/1)
        |> calculate()
    end
  end

  def run_loop() do

    result =
      try do

        IO.gets("Enter a statement: ")
          |> String.trim()
          |> String.split()
          |> evaluate()

      rescue
        e -> e.message

      end

    cond do
      is_bitstring(result) ->
        IO.puts result
        IO.puts "\n"
        run_loop()

      result != :stop ->
        IO.puts result[:value]
        IO.puts "\n"
        run_loop()

    end

  end
end

IO.puts "Hello, welcome to the Elixir calculator.\nEnter 'q' to quit.\n"

Calculator.run_loop()

IO.puts "Thank you, have a great day\n"

