using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CalendarShop.Api.Models
{
    [Table("UserAddresses")]
    public class UserAddress
    {
        [Key]
        public int AddressId { get; set; }
        
        public int UserId { get; set; }
        public User User { get; set; } = null!;

        [Required]
        [MaxLength(100)]
        public string ReceiverName { get; set; } = string.Empty;

        [Required]
        [MaxLength(20)]
        public string ReceiverPhone { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string Province { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string District { get; set; } = string.Empty;

        [MaxLength(100)]
        public string? Ward { get; set; }

        [Required]
        [MaxLength(255)]
        public string AddressLine { get; set; } = string.Empty;

        public bool IsDefault { get; set; }

        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
    }
}
