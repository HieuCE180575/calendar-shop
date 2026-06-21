using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CalendarShop.Api.Repositories;

public interface IRepository<T> where T : class
{
    IQueryable<T> Entities { get; }
    Task<T?> GetByIdAsync(object id);
    Task AddAsync(T entity);
    void Update(T entity);
    void Delete(T entity);
    void RemoveRange(IEnumerable<T> entities);
    Task SaveChangesAsync();
}
