defmodule Utils do
  def async_timeout(func, timeout) do
    pid = Task.async(func)
    try do
      Task.await(pid, timeout)
    catch
      :exit, _ -> nil
    end
  end
end
