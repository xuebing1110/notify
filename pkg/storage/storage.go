package storage

import (
	"github.com/xuebing1110/notify/pkg/models"
)

var GlobalStore Storage

type Storage interface {
	SaveSession(sess_3rd string, user_id string) error
	QuerySession(sess_3rd string) (string, error)

	UpdateUser(uid string, props map[string]interface{}) error
	AddUser(user *models.User) error
	GetUser(uid string) (*models.User, error)
	Exist(uid string) bool

	AddEnergy(uid, energy string) error
	GetEnergyCount(uid string) int64
	PopEnergy(uid string) (string, error)

	AddContact(uid string, contact *models.MaskUserInfo) error
	GetContact(uid, contact_id string) (*models.MaskUserInfo, error)
	ListContacts(uid string) ([]*models.MaskUserInfo, error)
	UpdateContact(uid string, contact *models.MaskUserInfo) error
	DelContact(uid, contact_id string) error
}
